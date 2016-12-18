'use strict';

/**
 * @ngdoc function
 * @name testAppApp.controller:SelectbizCtrl
 * @description
 * # SelectbizCtrl
 * Controller of the testAppApp
 */
angular.module('testAppApp')
    .controller('SelectbizCtrl', function(advertisersData) {
        advertisersData.getData();
    });