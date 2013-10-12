/**
 * @file
 * A JavaScript file for the theme.
 *
 * In order for this JavaScript to be loaded on pages, see the instructions in
 * the README.txt next to this file.
 */

// JavaScript should be made compatible with libraries other than jQuery by
// wrapping it with an "anonymous closure". See:
// - https://drupal.org/node/1446420
// - http://www.adequatelygood.com/2010/3/JavaScript-Module-Pattern-In-Depth
(function ($, Drupal, window, document, undefined) {


// To understand behaviors, see https://drupal.org/node/756722#behaviors
Drupal.behaviors.navigation = {
  attach: function(context, settings) {
    
    var broken = $('body').hasClass('mini-header') ? true : false;
    
    $(window).scroll(function() {
      var scrolltop = $(this).scrollTop();
      var topBreak = 25;
      var miniWidth = 480;
      var w = $(window).width();

      if (scrolltop >= topBreak && w > miniWidth) {
        $('body').addClass('mini-header');
        $('body').removeClass('normal-header');
        window.broken = true;
      }
      else if (scrolltop <= (topBreak - 5) && w > miniWidth) {
        $('body').removeClass('mini-header');
        $('body').addClass('normal-header');
        window.broken = false;
      }
      
      $('a.header__logo').click(function(event) {
        if (window.broken == true) {
          event.preventDefault();
          $('body').removeClass('mini-header');
          window.broken = false;
        }
      });
      
    });  
      

  }
};


})(jQuery, Drupal, this, this.document);
