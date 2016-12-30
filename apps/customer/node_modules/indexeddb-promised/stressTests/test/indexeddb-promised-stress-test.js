var chai = require("chai");
var should = chai.should();
var Builder = require("../../js/indexeddb-promised");
var Q = require('q');
var _ = require('lodash');

var testCount = 1;
var log = function(msg) {
  console.log(testCount + ": " + msg);
};

describe('indexeddb-promised', function() {

  var indexeddb;

  before('Get latest testdb version', function() {
    var defer = Q.defer();

    indexedDB.webkitGetDatabaseNames().onsuccess = function(event) {
      var databases = event.target.result;
      var max = 0;
      for(var i=0;i < databases.length;i++) {
        var databaseName = databases[i];
        var dbNumber = databaseName.replace(/^testdb/, '');
        dbNumber = parseInt(dbNumber, 10);
        if(dbNumber > max) {
          max = dbNumber;
        }
      }

      defer.resolve(max);
    };

    return defer.promise
    .then(function(max) {
      testCount = max + 1;
    });
  });

  var createDbWithTestObjStore = function() {
    var builder = new Builder('testdb' + testCount);
    builder.setVersion(1);
    builder.addObjectStore({name: 'testObjStore', keyType: {autoIncrement: true}});

    var indexeddb = builder.build();

    return indexeddb;
  };

  beforeEach('preparing test database', function() {
    indexeddb = createDbWithTestObjStore();

    return indexeddb.getDb();
  });

  afterEach('increasing test count', function() {
    testCount++;
    return Q(null);
  });


  describe('Cursors', function() {
    it('should test the maximum amount of data that can be inserted and iterate in reverse order', function() {
      log('STARTING test the maximum amount of data that can be inserted and iterate in reverse order.');
      var numberOfRecords = 524;
      var LENGTH = 1 * Math.pow(10, 6); // 1MB
      var addPromises = createAddPromises(numberOfRecords, LENGTH);

      function test() {
        return indexeddb.testObjStore.openCursor(null, 'prev').then(function(cursor) {
          var results = [];

          for(var record of cursor) {
            results.push(record);

            var blob = record.value.data;
            checkData(blob);

            log('Iterating over record: ' + record.key + " | " + record.value.description + " | data");
          }

          var keys = _.pluck(results, 'key');
          var values = _.pluck(results, 'value.description');

          var expectedKeys = [];
          var expectedValues = [];
          for(var i=numberOfRecords;i >= 1;i--) {
            expectedKeys.push(i);
            expectedValues.push('testValue'+i);
          }

          keys.should.eql(expectedKeys);
          values.should.eql(expectedValues);
        });
      }

      return Q.all(addPromises)
      .tap(function() {
        log('Done adding records.');
      })
      .then(test)
      .thenResolve("COMPLETED test the maximum amount of data that can be inserted and iterate in reverse order.")
      .then(log);
    });

  });

  describe('Progessive Cursors', function() {
    it('should create a cursor and be able to retrieve data while it becomes available', function() {
      log('STARTING create and use cursor and retrieve data while it becomes available test.');


      var numberOfRecords = 60;
      var LENGTH = 8.7 * Math.pow(10, 6); // 8.7MB
      var addPromises = createAddPromises(numberOfRecords, LENGTH);

      function test() {
        return indexeddb.testObjStore.openProgressiveCursor(null, 'prev').then(function(cursor) {
          var results = [];
          var promises = [];

          for(var recordPromise of cursor) {
            promises.push(recordPromise);
            recordPromise.then(function(record) {
              results.push(record);
              log('Received record: ' + record.key + " | " + record.value.description + " | data");
            });
          }

          return Q.all(promises).then(function() {
            var keys = _.pluck(results, 'key');
            var values = _.pluck(results, 'value.description');

            var expectedKeys = [];
            var expectedValues = [];
            for(var i=numberOfRecords;i >= 1;i--) {
              expectedKeys.push(i);
              expectedValues.push('testValue'+i);
            }

            keys.should.eql(expectedKeys);
            values.should.eql(expectedValues);

            results.forEach(function(result) {
              var blob = result.value.data;
              blob.size.should.equal(LENGTH);
              checkData(blob);
              var tmp = [];
            });
          });

        });
      }

      return Q.all(addPromises)
      .tap(function() {
        log('Done adding records.');
      })
      .then(test)
      .thenResolve("COMPLETED create and use cursor and retrieve data while it becomes available test.")
      .then(log);
    });

  });

  function createAddPromises(numberOfRecords, lengthOfDataInBytes, store) {
    var addPromises = [];
    for(var i=1;i <= numberOfRecords;i++) {
      var rawData = new ArrayBuffer(lengthOfDataInBytes);
      var dataAccess = new Uint32Array(rawData);
      for(var j=0;j < dataAccess.length;j++) {
        dataAccess[j] = j;
      }
      var blob = new Blob([dataAccess], {type: 'application/octet-binary'});
      if(store) {
        addPromises.push(store.add({description: "testValue" + i, data: blob}));
      } else {
        addPromises.push(
          indexeddb.testObjStore.add({description: "testValue" + i, data: blob})
        );
      }
    }

    return addPromises;
  }

  xdescribe('Add and open cursor using execTransaction()', function() {

    function createAddRecordsOperation(numberOfRecords, lengthOfDataInBytes) {
      function addRecords(transaction) {
        var objectStore = transaction.objectStore("testObjStore");

        for(var i=1;i <= numberOfRecords;i++) {
          var rawData = new ArrayBuffer(lengthOfDataInBytes);
          var dataAccess = new Uint32Array(rawData);
          for(var j=0;j < dataAccess.length;j++) {
            dataAccess[j] = j;
          }
          var blob = new Blob([dataAccess], {type: 'application/octet-binary'});
          (function(k) {
            objectStore.add({description: "testValue" + k, data: blob});
          })(i);
        }

        return null;
      }

      return addRecords;
    }

    function createTraverseAllOperation(done) {
      function traverseAll(transaction) {
        var objectStore = transaction.objectStore("testObjStore");

        objectStore.openCursor(null, "prev").onsuccess = function(event) {
          var cursor = event.target.result;
          if (cursor) {
            log('Received record: ' + cursor.key + " | " + cursor.value.description + " | data");
            var blob = cursor.value.data;
            checkData(blob);
            cursor.continue();
          } else {
            done.resolve(null);
          }
        };

        return null;
      }

      return traverseAll;
    }

    it('should add records and open a cursor through them', function() {
      var numberOfRecords = 20;
      var lengthOfDataInBytes = 2 * Math.pow(10, 6); // 2MB
      var done = Q.defer();

      var addRecords = createAddRecordsOperation(numberOfRecords, lengthOfDataInBytes);
      var traverseAll = createTraverseAllOperation(done);

      return indexeddb.execTransaction([addRecords, traverseAll], ['testObjStore'], 'readwrite')
      .thenResolve(done.promise);
    });

    it('should add records and the cursor should insert elements in an array', function() {
      var numberOfRecords = 20;
      var lengthOfDataInBytes = 2 * Math.pow(10, 6); // 2MB
      var done = Q.defer();
      var records = [];

      var addRecords = createAddRecordsOperation(numberOfRecords, lengthOfDataInBytes);

      function traverseAll(transaction) {
        var objectStore = transaction.objectStore("testObjStore");

        objectStore.openCursor(null, "prev").onsuccess = function(event) {
          var cursor = event.target.result;
          if (cursor) {
            records.push({key: cursor.key, value: cursor.value});
            cursor.continue();
          } else {
            done.resolve(null);
          }
        };

        return null;
      }

      return indexeddb.execTransaction([addRecords, traverseAll], ['testObjStore'], 'readwrite')
      .thenResolve(done.promise)
      .then(function() {
        records.forEach(function(record) {
          log('Received record: ' + record.key + " | " + record.value.description + " | data");
          var blob = record.value.data;
          checkData(blob);
        });
      });
    });

  });

  xdescribe('test limits of adding data', function() {
    it('should be able to add huge amounts of data in multiple object stores', function() {
      var numberOfRecords = 25;
      var LENGTH = 8.7 * Math.pow(10, 6); // 8.7MB
      var builder = new Builder("testdb2_" + testCount);
      var indexeddb2 = builder.setVersion(1)
      .addObjectStore({
        name: 'testObjStore1',
        keyType: {autoIncrement: true}
      })
      .addObjectStore({
        name: 'testObjStore2',
        keyType: {autoIncrement: true}
      })
      .addObjectStore({
        name: 'testObjStore3',
        keyType: {autoIncrement: true}
      })
      .addObjectStore({
        name: 'testObjStore4',
        keyType: {autoIncrement: true}
      })
      .build();

      var addPromises1 = createAddPromises(numberOfRecords, LENGTH, indexeddb2.testObjStore1);
      var addPromises2 = createAddPromises(numberOfRecords, LENGTH, indexeddb2.testObjStore2);
      var addPromises3 = createAddPromises(numberOfRecords, LENGTH, indexeddb2.testObjStore3);
      var addPromises4 = createAddPromises(numberOfRecords, LENGTH, indexeddb2.testObjStore4);

      return Q.all(addPromises1)
      .then(function() {
        log('Done adding 1st batch of add promises');
      })
      .thenResolve(Q.all(addPromises2))
      .then(function() {
        log('Done adding 2nd batch of add promises');
      })
      .thenResolve(Q.all(addPromises3))
      .then(function() {
        log('Done adding 3rd batch of add promises');
      })
      .thenResolve(Q.all(addPromises4))
      .then(function() {
        log('Done adding 4rd batch of add promises');
      });

    });

    it('should be able to add huge amounts of data in multiple databases', function() {
      var numberOfRecords = 25;
      var LENGTH = 8.7 * Math.pow(10, 6); // 8.7MB
      var builder1 = new Builder("testdb1_" + testCount);
      var indexeddb1 = builder1.setVersion(1)
      .addObjectStore({
        name: 'testObjStore',
        keyType: {autoIncrement: true}
      })
      .build();

      var builder2 = new Builder("testdb2_" + testCount);
      var indexeddb2 = builder2.setVersion(1)
      .addObjectStore({
        name: 'testObjStore',
        keyType: {autoIncrement: true}
      })
      .build();

      var builder3 = new Builder("testdb3_" + testCount);
      var indexeddb3 = builder3.setVersion(1)
      .addObjectStore({
        name: 'testObjStore',
        keyType: {autoIncrement: true}
      })
      .build();

      var builder4 = new Builder("testdb4_" + testCount);
      var indexeddb4 = builder4.setVersion(1)
      .addObjectStore({
        name: 'testObjStore',
        keyType: {autoIncrement: true}
      })
      .build();

      var addPromises1 = createAddPromises(numberOfRecords, LENGTH, indexeddb1.testObjStore);
      var addPromises2 = createAddPromises(numberOfRecords, LENGTH, indexeddb2.testObjStore);
      var addPromises3 = createAddPromises(numberOfRecords, LENGTH, indexeddb3.testObjStore);
      var addPromises4 = createAddPromises(numberOfRecords, LENGTH, indexeddb4.testObjStore);

      return Q.all(addPromises1)
      .then(function() {
        log('Done adding 1st batch of add promises');
      })
      .thenResolve(Q.all(addPromises2))
      .then(function() {
        log('Done adding 2nd batch of add promises');
      })
      .thenResolve(Q.all(addPromises3))
      .then(function() {
        log('Done adding 3rd batch of add promises');
      })
      .thenResolve(Q.all(addPromises4))
      .then(function() {
        log('Done adding 4rd batch of add promises');
      });

    });

  });

  function checkData(blob) {
    var reader = new FileReader();
    reader.addEventListener("loadend", function() {
       //var data = [];
       var rawData = reader.result;
       var dataAccess = new Uint32Array(rawData);
       for(var i=0;i < dataAccess.length;i++) {
         //data.push(dataAccess[i]);
         dataAccess[i].should.equal(i);
       }
       //log('data: ' + data);
    });
    reader.readAsArrayBuffer(blob);
  }

});
