'use strict';

describe('Controller: BusinessDetailsCtrl', function () {

  // load the controller's module
  beforeEach(module('testAppApp'));

  var BusinessDetailsCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    BusinessDetailsCtrl = $controller('BusinessDetailsCtrl', {
      $scope: scope
      // place here mocked dependencies
    });
  }));

  it('should attach a list of awesomeThings to the scope', function () {
    expect(BusinessDetailsCtrl.awesomeThings.length).toBe(3);
  });
});
