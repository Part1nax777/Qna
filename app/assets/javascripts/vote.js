$(document).on('turbolinks:load', function() {
    $('.vote').on('ajax:success', function(e) {
        var xhr = e.detail[0];
        var resourceName = xhr['resourceName'];
        var resourceId = xhr['resourceId'];
        var resourceScore = xhr['resourceScore'];

        $('.' + resourceName + '-' + resourceId + ' .rating').html(resourceScore);
    });
});