'use strict';

describe('Directive: subscribeButton', function () {

  // load the directive's module
  beforeEach(module('testAppApp'));

  var element,
    scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should make hidden element visible', inject(function ($compile) {
    element = angular.element('<subscribe-button></subscribe-button>');
    element = $compile(element)(scope);
    expect(element.text()).toBe('this is the subscribeButton directive');
  }));
});
