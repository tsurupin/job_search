# indexeddb-promised

This library implements an interface for indexedDB where all the functions return a promise for the result of the underlying indexedDB function they call.

It also uses the builder pattern to configure the database schema and return an object to interact with it.

Bug reports are welcome at [https://github.com/vergara/indexeddb-promised](https://github.com/vergara/indexeddb-promised).

## Getting started
### Using browserify
In an empty folder, run the commands:
```
npm install -g gulp browserify
npm install indexeddb-promised vinyl-source-stream
```
Create the files:

gulpfile.js:
```javascript
var browserify = require('browserify');
var gulp = require('gulp');
var source = require('vinyl-source-stream');

var sourceFile = './js/app.js';
var destFolder = './';
var destFile = 'bundle.js';

gulp.task('browserify', function() {
    var bundler = browserify({
    cache: {}, packageCache: {}, fullPaths: true,
    entries: [sourceFile],
    extensions: ['.js'],
    debug: true
  });

  var bundle = function() {
    return bundler
      .bundle()
      .pipe(source(destFile))
      .pipe(gulp.dest(destFolder));
  };

  return bundle();
});

gulp.task('default', ['browserify']);
```
index.html:
```html
<!DOCTYPE html>
<html>
  <head>
    <script type="text/javascript" src="bundle.js"></script>
  </head>
  <body>
    Press Enter to create note.<br>
    Title: <input id="title" type="text"><br>
    Contnet: <input id="content" type="text"><br>
    <br>
    Notes:
    <table>
      <tr>
        <th>Sorted by title</th>
        <th>Sorted by creation date</th>
      </tr>
      <tr>
        <td>
          <dl id="sortedByTitle">
        </td>
        <td>
          <dl id="sortedByCreated">
        </td>
      </tr>
    </table>
  </body>
</html>
```
js/app.js:
```javascript
var app = require('./index')();
```
js/index.js:
```javascript
module.exports = function() {
  window.addEventListener("load", function load(event){
    var Builder = require('indexeddb-promised');
    var builder = new Builder('appDB');
    var appDB = builder
    .setVersion(1)
    .addObjectStore(
      {
        name: 'notes',
        keyType: {keyPath: 'id', autoIncrement: true},
        indexes: [
          {
            name: 'title',
            keyPath: 'title',
            options: {unique: false}
          },
          {
            name: 'created',
            keyPath: 'created',
            options: {unique: false}
          }
        ]
      }
    )
    .build();

    var contentElement = document.getElementById('content');
    var titleElement = document.getElementById('title');
    contentElement.addEventListener('keypress', addNewNote);
    titleElement.addEventListener('keypress', addNewNote);

    function addNewNote(event) {
      if(event.keyCode === 13) {
        var noteContent = contentElement.value;
        var title = titleElement.value || 'Note from '+new Date();
        var newNote = {
          title: title,
          content: noteContent,
          created: new Date()
        };
        appDB.notes.add(newNote);
        console.log('note added: '+JSON.stringify(newNote));
        contentElement.value = '';
        titleElement.value = '';
        titleElement.focus();

        updateViews();
      }
    }

    var sortedByTitle = document.getElementById('sortedByTitle');
    var sortedByCreated = document.getElementById('sortedByCreated');

    function updateViews() {
      while (sortedByTitle.firstChild) {
        sortedByTitle.removeChild(sortedByTitle.firstChild);
      }

      while (sortedByCreated.firstChild) {
        sortedByCreated.removeChild(sortedByCreated.firstChild);
      }

      appDB.notesByTitle.getAll().then(function(notes) {
        notes.forEach(function(note) {
          var dt = document.createElement("dt");
          dt.appendChild(document.createTextNode(note.title));
          var dd = document.createElement("dd");
          dd.appendChild(document.createTextNode(note.content +
            " -- Created on: " + note.created));

          sortedByTitle.appendChild(dt);
          sortedByTitle.appendChild(dd);
        });
      });

      appDB.notesByCreated.getAll().then(function(notes) {
        notes.forEach(function(note) {
          var dt = document.createElement("dt");
          dt.appendChild(document.createTextNode(note.title));
          var dd = document.createElement("dd");
          dd.appendChild(document.createTextNode(note.content +
            " -- Created on: " + note.created));

          sortedByCreated.appendChild(dt);
          sortedByCreated.appendChild(dd);
        });
      });
    }

    updateViews();
  },false);
};
```
Run the command:
```
gulp
```

Now you can open the index.html file from your browser and give it a try.

## Creating an instance of indexeddb and a database schema

```javascript
var Builder = require('indexeddb-promised');

var builder = new Builder('myApp')
.setVersion(1)
.addObjectStore(
  {
    name: 'users',
    keyType: {keyPath: 'id'},
    indexes: [
      {
        name: 'email',
        keyPath: 'email',
        {unique: true}
      }
    ]
  })
.addObjectStore(
  {name: 'orders',
  keyType: {autoIncrement: true}
  })
.addObjectStore(
  {name: 'products',
  keyType: {keyPath: 'id'}
  });

var myAppDB = builder.build();

var user1 = myAppDB.users.get(25);
var user2 = myAppDB.usersByEmail.get('user@example.com');

```

### Functions
#### Builder Constructor: new Builder(dbname)
*dbname* string represents the name of the database that is going to be opened or created in indexedDB.
#### addObjectStore(storeDefinitionObject)
*storeDefinitionObject*:

**name:** name of the store in indexedDB. Also used to expose an objectStore with the same name in the db object:

```javascript
var myAppDB = new Builder('myApp')
.addObjectStore(
  {
    name: 'users',
    ...
...
.build();

myAppDB.users.add({
  id: 32,
  email: 'user2@example.com'
});
```

**keyType:** can be {autoIncrement: true}, {keyPath: key}, both, or undefined for out of line keys.

**indexes:** contains index definition objects:

  **name:** makes access to the index available through objectStoreByName.
  ```javascript
  var user = myAppDB.usersByEmail.get('user@example.com');
  ```
  **keyPath:** name of the key in the value object used for the index to lookup data.

  **indexOptions:** see [the Mozilla documentation on createIndex](https://developer.mozilla.org/en-US/docs/Web/API/IDBObjectStore/createIndex). Example: ```{unique: false}```

Example:
```javascript
var Builder = require('indexeddb-promised');

var myAppDB = new Builder('myApp')
.setVersion(1)
.addObjectStore(
  {
    name: 'users',
    keyType: {keyPath: 'id'},
    indexes: [
      {
        name: 'email',
        keyPath: 'email',
        options: {unique: true}
      }
    ]
  })
.build();
```

#### setVersion(number)
*number* must be an integer. Changes in the myAppDB, like adding objectStores or indexes to existing objectStores, must be accompanied with an increase in the version number in the setVersion() function in order for the schema changes to take effect.

#### setDebug()
Makes a database with name 'dbName' available in the global object as 'indexeddbPromised_dbName'.

## API
### indexeddb.objectStore.add(record\[, key\])
*record* can be any type of object. If not using the keyPath key type in the object store, then it can also be a primitive.

Returns a promise for the key of the record. Useful when using key type autoIncrement: true.

### indexeddb.objectStore.count()
Returns a promise for an integer number that represents the number of records in the object store.

### indexeddb.objectStore.get(key)
Return a promise for the value of the record identified by *key*.

### indexeddb.objectStore.delete(key)
Returns a promise resolved with *null*.

### indexeddb.objectStore.clear()
Deletes all records from the object store. Returns a promise resolved with *null*.

### indexeddb.objectStore.put(record\[, key\])
Similar to *add()*, but replaces existing records. The *key* parameter is not required if keyPath key type is used and the record has the property used as keyPath populated.

### indexeddb.objectStore.getAll()
Returns a promise for an array with all values from all records.

### indexeddb.objectStore.getAllKeys()
Returns a promise for an array with the keys of all records.

### indexeddb.objectStore.openCursor(\[IDBKeyRange\]\[, 'prev'\])
Returns a promise for a cursor that can be iterated using the standard iterator syntax:
```javascript
indexeddb.testObjStore
// Iterate key-value pairs in reverse order from 4 through 2, including 4 and 2
.openCursor(IDBKeyRange.bound(2, 4, false, false), 'prev')
.then(function(cursor) {

  for(var record of cursor) {
    // Do something with each record
  }

});
```

For more information on *IDBKeyRange* see the [Mozilla documentation on IDBKeyRange](https://developer.mozilla.org/en-US/docs/Web/API/IDBKeyRange).

### indexeddb.objectStore.openProgressiveCursor(\[IDBKeyRange\]\[, 'prev'\])
Similar to openCursor(), but optimized for memory usage. Use this method when retrieving big amounts of data. If the amounts of data are small, openCursor() is faster.

Returns a promise for a cursor that can be iterated using the standard iterator syntax. Each result returned by the iterator is a promise for a record. This is different to how openCursor() works, which returns the record directly. This way of working allows to destroy each record after it has been used so memory usage can be kept low while the iteration is in progress.

Another advantage of this method over openCursor() is that the records can be used immediately as they become available. In the case of openCursor(), all the records must be delivered by the database before they can be used.

```javascript
indexeddb.testObjStore
.openProgressiveCursor(null, 'prev').then(function(cursor) {

  for(var recordPromise of cursor) {
    recordPromise.then(function(record) {
      // Do something with the record
    });
  }

});
```

### indexeddb.execTransaction(operations,objectStores[, mode])
Low level method to execute a transaction in the database. The first parameter is an array of functions where each function is an operation that is to be executed in the transaction. The second array contains strings with the names of the obectStores used in the transaction. The last parameter is the transaction mode which can be "readonly" (default) or "readwrite".

The function returns a promise for an array with the accumulated results of each operation. Falsey values are accumulated as *null*.

The operations are defined as follows:

```javascript
function operation(transaction) {
  // Perform operations using indexedDB's API
  ...
  var objectStore = transaction.objectStore("testObjStore");
  var request = objectStore.get(1);
  return request;
}
```

Operations take a transaction as a parameter that can be used to retrieve objectStores and indexes. They can return a request if the result is useful, or null if the database operation doesn't return a value or the result of the operation is to be discarded.

Full example:

```javascript
var testRecord = {testKey: "testValue"};

var addRecord = function(transaction) {
  var objectStore = transaction.objectStore("testObjStore");
  var request = objectStore.add(testRecord);
  return request;
};

var getRecords = function(transaction) {
  var objectStore = transaction.objectStore("testObjStore");
  var records = [];

  objectStore.openCursor().onsuccess = function(event) {
    var cursor = event.target.result;
    var result;
    if (cursor) {
      var record = {};
      record.key = cursor.key;
      record.value = cursor.value;
      records.push(record);
      cursor.continue();
    }
  };

  return records;
};

var deleteRecord = function(transaction) {
  var objectStore = transaction.objectStore("testObjStore");
  var request = objectStore.delete(1);
  return request;
};

var transactions = [addRecord, getRecords, deleteRecord];
return indexeddb.execTransaction(transactions,
  ['testObjStore'], "readwrite")
.then(function(results) {
  // results[0] contains the key of the record added in the first operation.
  // results[1] contains an array with the records from the database (only one record in this example).
  // results[2] contains the result of the deleteRecord() operation, which is undefined.
})
```
