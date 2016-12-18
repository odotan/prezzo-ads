'use strict';

/**
 * @ngdoc function
 * @name testAppApp.controller:BusinessDetailsCtrl
 * @description
 * # BusinessDetailsCtrl
 * Controller of the testAppApp
 */
angular.module('testAppApp')
  .controller('BusinessDetailsCtrl', function (advertisersData) {
    advertisersData.getData();
  });
