'use strict';

describe('Service: advertisersData', function () {

  // load the service's module
  beforeEach(module('testAppApp'));

  // instantiate service
  var advertisersData;
  beforeEach(inject(function (_advertisersData_) {
    advertisersData = _advertisersData_;
  }));

  it('should do something', function () {
    expect(!!advertisersData).toBe(true);
  });

});
