'use strict';

/**
 * @ngdoc directive
 * @name testAppApp.directive:subscribeButton
 * @description
 * # subscribeButton
 */
angular.module('testAppApp')
  .directive('subscribeButton', function () {
    return {
      templateUrl: '../views/subscribeButton.html',
      scope: {
         product: '='
      },
      restrict: 'E',
      link: function postLink($scope, element, attrs) {

        $scope.subscription_values = {
          'on':{
            'icon_src': "graphics/banners/Icon-notifications-black-full-on-200x200.png",
            'class': "product-reminder-subscribed"
          },
          'off':{
            'icon_src': "graphics/banners/Icon-notifications-black-empty-off-200x200.png",
            'class': "product-reminder-unsubscribed"
          }
        }

        $scope.clickReminder = function(product){
            if (product.remindMe == 'on'){
              product.remindMe = 'off';
            } else{
              product.remindMe = 'on';
            }
        }

      }
    };
  });
