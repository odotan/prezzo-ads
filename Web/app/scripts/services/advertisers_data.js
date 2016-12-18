'use strict';

/**
 * @ngdoc service
 * @name testAppApp.advertisersData
 * @description
 * # advertisersData
 * Service in the testAppApp.
 */
angular.module('testAppApp')
  .service('advertisersData', function ($http, $rootScope) {
    // AngularJS will instantiate a singleton by calling "new" on this function
    $rootScope.advertisers = [];
    this.getData = function() {
        return $http.get('data/advertisers.json', {cache: true})
                .then(function(res) {
                    var advertisers = [];
                    for (var adv in res.data) {
                        advertisers.push(res.data[adv]);
                    }
                    $rootScope.advertisers = res.data;
                });
    };
  });
