$(document).on('turbolinks:load', function() {

    App.commentsSubscription = App.cable.subscriptions.create('CommentsChannel', {
        connected: function() {
            questionId = $('.question').attr('id');
            this.perform('follow', {id: questionId});
        },
        received: function(data) {
            var commentData = data.comment;
            var commentElement = JST['templates/comments/comment']({
                comment: commentData
            });
            $(".comments-" + commentData.commentable_id).append(commentElement);
        }
    });
});