$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    })

    App.cable.subscriptions.create('QuestionsChannel', {
        connected: function() {
            this.perform('follow')
        },

        received: function(data) {
           $('.questions').append(data)
        }
    })
});