var chai = require("chai");
var should = chai.should();
var expect = chai.expect;
chai.use(require('chai-fuzzy'));
var Builder = require("../js/indexeddb-promised");
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

  describe('#constructor', function() {
    it('should create an object that has a database', function() {
      log('STARING Create DB test.');
      should.exist(indexeddb);
      indexeddb.should.have.property('getDb');
      indexeddb.getDb.should.be.a('function');

      var hasObjectStore = function(db) {
        should.exist(db);
        db.should.have.property('createObjectStore');
      };

      return indexeddb.getDb()
      .then(hasObjectStore)
      .thenResolve("COMPLETED Create DB test.")
      .then(log);
    });

    it('should create an objectStore in the database', function() {
      log('STARTING Create ObjectStore test.');
      var db = indexeddb.getDb();

      var hasTestObjStore = function(db) {
        db.objectStoreNames.should.containOneLike('testObjStore');
      };

      return db.then(hasTestObjStore)
      .thenResolve("COMPLETED Create ObjectStore test.")
      .then(log);
    });

    it('should create an objectStore with autoIncrement key in the database without upgrade function', function() {
      log('STARTING Create ObjectStore with autoIncrement key without upgrade function test.');
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore({name: 'testObjStore', keyType: {autoIncrement : true}});

      var db = builder.build().getDb();

      var hasTestObjStore = function(db) {
        db.objectStoreNames.should.containOneLike('testObjStore');
      };

      return db.then(hasTestObjStore)
      .thenResolve("COMPLETED Create ObjectStore with autoIncrement key without upgrade function test.")
      .then(log);
    });

    it('should create an objectStore with keyPath key in the database without upgrade function', function() {
      log('STARTING Create ObjectStore with keyPath key without upgrade function test.');
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore({name: 'testObjStore1', keyType: {autoIncrement: true}})
      .addObjectStore({name: 'testObjStore2', keyType: {keyPath: 'id'}})
      .addObjectStore({name: 'testObjStore3', keyType: {autoIncrement: 'id'}})
      .setDebug();

      var db = builder.build().getDb();

      var hasTestObjStore = function(db) {
        db.objectStoreNames.should.containOneLike('testObjStore1');
        db.objectStoreNames.should.containOneLike('testObjStore2');
        db.objectStoreNames.should.containOneLike('testObjStore3');
      };

      return db.then(hasTestObjStore)
      .thenResolve("COMPLETED Create ObjectStore with keyPath key without upgrade function test.")
      .then(log);
    });
  });

  describe('#execTransaction()', function() {
    it('should execute a transaction that creates a record, gets the record, and then deletes the record', function() {
      log('STARTING execTransaction.');
      var testRecord = {testKey: "testValue"};

      var addRecord = function(tx) {
        log('adding record...');
        var objectStore = tx.objectStore("testObjStore");
        var request = objectStore.add(testRecord);
        return request;
      };

      var getRecord = function(tx) {
        log('reading...');
        var objectStore = tx.objectStore("testObjStore");
        var records = [];

        objectStore.openCursor().onsuccess = function(event) {
          var cursor = event.target.result;
          var result;
          if (cursor) {
            var record = {};
            record.key = cursor.key;
            record.value = cursor.value;
            //log('found record: '+JSON.stringify(record, null, 2));
            records.push(record);
            cursor.continue();
          }
        };

        return records;
      };

      var deleteRecord = function(tx) {
        log('deleting record...');
        var objectStore = tx.objectStore("testObjStore");
        var request = objectStore.delete(1);
        return request;
      };

      log('executing transaction now.');
      var transactions = [addRecord, getRecord, deleteRecord];
      return indexeddb.execTransaction(transactions,
        ['testObjStore'], "readwrite")
      .tap(function(results) {
        log(JSON.stringify(results));
      })
      .then(function(results) {
        results.should.have.length(transactions.length);
        results[0].should.be.a('number');

        results[1][0].should.eql({key: 1, value: {testKey: "testValue"}});
      })
      .thenResolve("COMPLETED Execute transaction test.")
      .then(log);
    });
  });

  describe('CRUD operations', function() {
    it('should add a record in the db', function() {
      log('STARTING add test');

      var testRecord = {testKey: "testValue"};

      var test = function(resultKey) {
        resultKey.should.eql(1);
        return indexeddb.testObjStore.get(1).then(function(result) {
          result.should.eql(testRecord);
        });
      };

      return indexeddb.testObjStore.add(testRecord)
      .then(test)
      .thenResolve("COMPLETED add test.")
      .then(log);
    });

    it('should add a record in the db using an out of line key', function() {
      log('STARTING add a record in the db using an out of line key test');
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore({name: 'testObjStore'});
      var indexeddb2 = builder.build();

      var test1 = function() {
        return indexeddb2.testObjStore.getAll()
        .tap(function(result) {
        })
        .then(function(result) {
          result.should.have.length(5);
          for(var i=1;i <= 5;i++) {
            result[i-1].should.eql({testKey: "testValue" + i});
          }
        });
      };

      var test2 = function() {
        var getPromises = [];

        for(var i=1;i <= 5;i++) {
          getPromises.push(indexeddb2.testObjStore.get('id'+i));
        }

        return Q.all(getPromises)
        .then(function(result) {
          for(var i=1;i <= 5;i++) {
            result.should.containOneLike({testKey: "testValue" + i});
          }
        });
      };

      var addPromises = [];
      for(var i=1;i <= 5;i++) {
        addPromises.push(
          indexeddb2.testObjStore.add({testKey: "testValue" + i}, 'id'+i)
        );
      }

      return Q.all(addPromises)
      .then(test1)
      .then(test2)
      .thenResolve("COMPLETED add a record in the db using an out of line key test.")
      .then(log);
    });

    it('should reject the promise when failure while adding', function() {
      log('STARTING reject the promise when failure while adding test');
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore({
        name: 'testObjStore',
        keyType: {keyPath: 'id', autoIncrement: false}
      });
      var indexeddb2 = builder.build();

      var testRecord = {id: 1, testKey: "testValue"};

      return indexeddb2.testObjStore.add(testRecord)
      .thenResolve(indexeddb2.testObjStore.add(testRecord))
      .then(function() {
        throw new Error("Test failed: add should have rejected.");
      }, function(error) {
        log('Test succeeded: caught exception with errorCode: ' + error.message);
      })
      .thenResolve("COMPLETED reject the promise when failure while adding test.")
      .then(log);
    });

    it('should retrieve the count of records in the db', function() {
      log('STARTING retrieve the count of records in the db test');
      var numberOfRecords = 5;
      var addPromises = [];

      for(var i=0;i < numberOfRecords;i++) {
        addPromises.push(indexeddb.testObjStore.add({testKey: "testValue" + i}));
      }

      function test() {
        return indexeddb.testObjStore.count().then(function(count) {
          log('Count: ' + count);
          count.should.equal(numberOfRecords);
        });
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve('COMPLETED retrieve the count of records in the db test')
      .then(log);
    });

    it('should delete a record in the db', function() {
      log('STARTING delete test');
      var testRecord = {testKey: "testValue"};

      var testAdded = function(resultKey) {
        resultKey.should.eql(1);
        return indexeddb.testObjStore.get(1).then(function(result) {
          result.should.eql(testRecord);
        });
      };

      var deleteRecord = function() {
        return indexeddb.testObjStore.delete(1);
      };

      var testDeleted = function() {
        return indexeddb.testObjStore.get(1).then(function(result) {
          expect(result).to.not.be.ok;
        });
      };

      return indexeddb.testObjStore.add(testRecord)
      .then(testAdded)
      .then(deleteRecord)
      .then(testDeleted)
      .thenResolve("COMPLETED delete test.")
      .then(log);
    });

    it('should clear all the objects in an object store', function() {
      log('STARTING clear all the objects in an object store test');
      var numberOfRecords = 5;
      var addPromises = [];

      for(var i=0;i < numberOfRecords;i++) {
        addPromises.push(indexeddb.testObjStore.add({testKey: "testValue" + i}));
      }

      function test() {
        return indexeddb.testObjStore.count()
        .then(function(count) {
          log('Before clear, count is: ' + count);
          count.should.equal(numberOfRecords);
        })
        .thenResolve(indexeddb.testObjStore.clear())
        .thenResolve(indexeddb.testObjStore.count())
        .then(function(count) {
          log('After clear, count is: ' + count);
          count.should.equal(0);
        });
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve('COMPLETED clear all the objects in an object store test')
      .then(log);
    });

    it('should update a record in the db', function() {
      log('STARTING update test');
      var testRecord = {testKey: "testValue"};
      var updatedRecord = {testKey: "updatedValue"};

      var testAdded = function(resultKey) {
        resultKey.should.eql(1);
        return indexeddb.testObjStore.get(1).then(function(result) {
          result.should.eql(testRecord);
        });
      };

      var updateRecord = function() {
        return indexeddb.testObjStore.put(updatedRecord, 1);
      };

      var testUpdated = function() {
        return indexeddb.testObjStore.get(1).then(function(result) {
          result.should.eql(updatedRecord);
        });
      };

      return indexeddb.testObjStore.add(testRecord)
      .then(testAdded)
      .then(updateRecord)
      .then(testUpdated)
      .thenResolve("COMPLETED update test.")
      .then(log);
    });

    it('should update a record in the db using keyPath', function() {
      log('STARTING update using keyPath test');
      var testRecord = {id: 1, testKey: "testValue"};
      var updatedRecord = {id: 1, testKey: "updatedValue"};
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore({name: 'testObjStore', keyType: {keyPath : 'id'}});
      var indexeddb2 = builder.build();

      var testAdded = function(resultKey) {
        resultKey.should.eql(1);
        return indexeddb2.testObjStore.get(1).then(function(result) {
          result.should.eql(testRecord);
        });
      };

      var updateRecord = function() {
        return indexeddb2.testObjStore.put(updatedRecord);
      };

      var testUpdated = function() {
        return indexeddb2.testObjStore.get(1).then(function(result) {
          result.should.eql(updatedRecord);
        });
      };

      return indexeddb2.testObjStore.add(testRecord)
      .then(testAdded)
      .then(updateRecord)
      .then(testUpdated)
      .thenResolve("COMPLETED update using keyPath test.")
      .then(log);
    });

    it('should get all records in the database', function() {
      log('STARTING get all records in the database test');
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore({name: 'testObjStore', keyType: {keyPath : 'id'}});
      var indexeddb2 = builder.build();

      var test = function() {
        return indexeddb2.testObjStore.getAll()
        .tap(function(result) {
          log('getAll(): ' + JSON.stringify(result));
        })
        .then(function(result) {
          result.should.have.length(5);
          for(var i=1;i <= 5;i++) {
            result[i-1].should.eql({id: i, testKey: "testValue" + i});
          }
        });
      };

      var addPromises = [];
      for(var i=1;i <= 5;i++) {
        addPromises.push(
          indexeddb2.testObjStore.add({id: i, testKey: "testValue" + i})
        );
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve("COMPLETED get all records in the database test.")
      .then(log);
    });

    it('should get all keys in the database', function() {
      log('STARTING get all keys in the database test');
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore({name: 'testObjStore', keyType: {keyPath : 'id'}});
      var indexeddb2 = builder.build();

      var test = function() {
        return indexeddb2.testObjStore.getAllKeys()
        .tap(function(result) {
          log('getAllKeys(): ' + JSON.stringify(result));
        })
        .then(function(result) {
          result.should.have.length(5);
          for(var i=1;i <= 5;i++) {
            result[i-1].should.eql(i);
          }
        });
      };

      var addPromises = [];
      for(var i=1;i <= 5;i++) {
        addPromises.push(
          indexeddb2.testObjStore.add({id: i, testKey: "testValue" + i})
        );
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve("COMPLETED get all keys in the database test.")
      .then(log);
    });

  });

  describe('Indexes', function() {
    it('should create an index and be able to use it', function() {
      log('STARTING create and use index test');
      var builder = new Builder('testdb2_' + testCount)
      .setVersion(1)
      .addObjectStore(
        {
          name: 'testObjStore',
          keyType: {keyPath : 'id'},
          indexes: [
            {
              name: 'testKey',
              keyPath: 'testKey',
              options: {unique: true}
            }
          ]
        }
      )
      .setDebug();

      var indexeddb2 = builder.build();

      var test = function() {
        return indexeddb2.testObjStoreByTestKey.get('testValue3')
        .tap(function(result) {
          log('found: '+JSON.stringify(result));
        })
        .then(function(result) {
          result.should.eql({id: 3, testKey: "testValue3"});
        });
      };

      var addPromises = [];
      for(var i=1;i <= 5;i++) {
        addPromises.push(
          indexeddb2.testObjStore.add({id: i, testKey: "testValue" + i})
        );
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve("COMPLETED create and use index test.")
      .then(log);
    });
  });

  describe('Cursors', function() {
    it('should create a cursor and be able to use it', function() {
      log('STARTING create and use cursor test.');
      var addPromises = [];
      for(var i=1;i <= 5;i++) {
        addPromises.push(
          indexeddb.testObjStore.add("testValue" + i)
        );
      }

      function test() {
        return indexeddb.testObjStore.openCursor().then(function(cursor) {
          var results = [];

          for(var record of cursor) {
            results.push(record);
          }

          var keys = _.pluck(results, 'key');
          var values = _.pluck(results, 'value');

          keys.should.eql([1, 2, 3, 4, 5]);
          values.should.eql(
            ['testValue1',
            'testValue2',
            'testValue3',
            'testValue4',
            'testValue5']);
        });
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve("COMPLETED create and use cursor test.")
      .then(log);
    });

    it('should create a cursor and iterate values 2 through 4', function() {
      log('STARTING create a cursor and iterate values 2 through 4.');
      var addPromises = [];
      for(var i=1;i <= 5;i++) {
        addPromises.push(
          indexeddb.testObjStore.add("testValue" + i)
        );
      }

      function test() {
        return indexeddb.testObjStore
        .openCursor(IDBKeyRange.bound(2, 4, false, false))
        .then(function(cursor) {
          var results = [];

          for(var record of cursor) {
            results.push(record);
          }

          var keys = _.pluck(results, 'key');
          var values = _.pluck(results, 'value');

          keys.should.eql([2, 3, 4]);
          values.should.eql(
            [
            'testValue2',
            'testValue3',
            'testValue4']);
        });
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve("COMPLETED create a cursor and iterate values 2 through 4.")
      .then(log);
    });

    it('should create a cursor and iterate the object store in reverse order', function() {
      log('STARTING create a cursor and iterate the object store in reverse order test.');
      var addPromises = [];
      for(var i=1;i <= 5;i++) {
        addPromises.push(
          indexeddb.testObjStore.add("testValue" + i)
        );
      }

      function test() {
        return indexeddb.testObjStore.openCursor(null, 'prev').then(function(cursor) {
          var results = [];

          for(var record of cursor) {
            results.push(record);
          }

          var keys = _.pluck(results, 'key');
          var values = _.pluck(results, 'value');

          keys.should.eql([5, 4, 3, 2, 1]);
          values.should.eql(
            ['testValue5',
            'testValue4',
            'testValue3',
            'testValue2',
            'testValue1']);
        });
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve("COMPLETED create a cursor and iterate the object store in reverse order test.")
      .then(log);
    });

  });

  describe('Progessive Cursors', function() {
    it('should create a cursor and be able to retrieve data while it becomes available', function() {
      log('STARTING create and use cursor and retrieve data while it becomes available test.');
      var addPromises = [];
      for(var i=1;i <= 6;i++) {
        addPromises.push(
          indexeddb.testObjStore.add("testValue" + i)
        );
      }

      function test() {
        return indexeddb.testObjStore.openProgressiveCursor(null, 'prev').then(function(cursor) {
          var results = [];
          var promises = [];

          for(var recordPromise of cursor) {
            promises.push(recordPromise);
            recordPromise.then(function(record) {
              results.push(record);
              log('Received record: ' + record.key + " | " + record.value);
            });
          }

          return Q.all(promises).then(function() {
            var keys = _.pluck(results, 'key');
            var values = _.pluck(results, 'value');

            keys.should.eql([6, 5, 4, 3, 2, 1]);
            values.should.eql(
              ['testValue6',
              'testValue5',
              'testValue4',
              'testValue3',
              'testValue2',
              'testValue1']);
          });

        });
      }

      return Q.all(addPromises)
      .then(test)
      .thenResolve("COMPLETED create and use cursor and retrieve data while it becomes available test.")
      .then(log);
    });

  });

});
