// Generated by CoffeeScript 1.4.0
(function() {
  var $, TimeParsingInput;

  if (typeof jQuery !== "undefined" && jQuery !== null) {
    $ = jQuery;
    $.fn.extend({
      timeinput: function(options) {
        return this.each(function(input_field) {
          return new TimeParsingInput(this);
        });
      }
    });
  }

  window.TimeParser = (function() {

    function TimeParser() {}

    TimeParser.to_minutes = function(string) {
      var hours, minutes, parts;
      string = string.toString().replace(/[^\d\:\.]/g, '');
      if (string === '') {
        return 0;
      }
      if (string.indexOf(":") >= 0) {
        parts = string.split(':');
        hours = parseFloat(parts[0] || 0);
        minutes = Math.floor(parseFloat(parts[1] || 0));
      } else if (string.indexOf(".") >= 0) {
        hours = parseFloat(string);
        minutes = 0;
      } else {
        hours = 0;
        minutes = parseFloat(string);
      }
      return Math.ceil(hours * 60 + minutes);
    };

    TimeParser.from_minutes = function(minutes) {
      var hours, mins;
      minutes = Math.floor(minutes);
      if (minutes < 0) {
        minutes = 0;
      }
      hours = Math.floor(minutes / 60.0);
      mins = minutes % 60;
      return "" + hours + ":" + (this.pad(mins.toString()));
    };

    TimeParser.clean = function(string) {
      var minutes;
      minutes = TimeParser.to_minutes(string);
      return TimeParser.from_minutes(minutes);
    };

    TimeParser.pad = function(str, max) {
      if (max == null) {
        max = 2;
      }
      if (str.length < max) {
        return this.pad("0" + str, max);
      } else {
        return str;
      }
    };

    return TimeParser;

  })();

  TimeParsingInput = (function() {

    function TimeParsingInput(elem) {
      this.$elem = $(elem);
      console.debug('storing ad timeparser', this);
      this.$elem.data('timeparser', this);
      this.create_hidden_field();
      this.$elem.change(function() {
        var $this, minutes;
        $this = $(this);
        minutes = TimeParser.to_minutes($(this).val());
        $this.data('timeparser').$hidden_field.val(minutes).trigger('change');
        return $this.val(TimeParser.from_minutes(minutes));
      });
      this.$elem.trigger('change');
      this.create_tooltip();
    }

    TimeParsingInput.prototype.create_hidden_field = function() {
      var field_name;
      field_name = this.$elem.attr('name');
      this.$hidden_field = $("<input type=\"hidden\" />").attr('name', field_name);
      this.$elem.after(this.$hidden_field);
      return this.$elem.attr('name', "" + field_name + "_display");
    };

    TimeParsingInput.prototype.create_tooltip = function() {
      var $wrapper;
      $wrapper = $('<div/>').css('position', 'relative').css('display', 'inline-block');
      this.$elem.wrap($wrapper);
      this.$tooltip = $('<span/>').addClass('tooltip').hide();
      this.$tooltip.text(this.$elem.val());
      this.$elem.after(this.$tooltip);
      this.$elem.data('tooltip', this.$tooltip);
      this.$elem.bind('keyup', function() {
        var val;
        val = $(this).val() || 0;
        return $(this).data('tooltip').text(TimeParser.clean(val));
      });
      this.$elem.bind('focus', function() {
        return $(this).data('tooltip').fadeIn('fast');
      });
      return this.$elem.bind('blur', function() {
        return $(this).data('tooltip').fadeOut('fast');
      });
    };

    return TimeParsingInput;

  })();

}).call(this);