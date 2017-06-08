/**
 * Created by Peter on 3/21/17.
 */

var user_id;
var show_responses = false;

/*
Performs following actions when document is ready
1. Sets global variable equal to artist id or user id extracted from DOM element containing it as data
2. Adds click listener to window that hides dropdown menu when user clicks anywhere else on the screen
3. Adds click listeners to review/discussion toggle buttons
 */
$(document).on('ready page:load', function(){
    user_id = $('#user_id_container').attr('data-user_id');
    console.log(user_id);

    window.onclick = function(e){
      if(!e.target.matches('.dropbtn')){
          var dropdowns = $('.dropdown-content');
          for(var i=0; i<dropdowns.length ;i++){
              if(dropdowns[i].classList.contains('show')){
                  dropdowns[i].classList.remove('show');
              }
          }
      }
    };

    $('#reviews_button').on('click', function(e) {
        console.log("Review button clicked");
        show_responses = false;
    });

    $('#discussion_button').on('click', function(e) {
        console.log("Discussion button clicked");
        show_responses = true;
    });

});

/*
Function that is called when user selects dropdown option of ordering shown reviews by age (updated_at time) on artist page
Removes all reviews currently shown on the screen and reloads 10 initial ones using helper function show_more_reviews()
*/
function orderReviewsByAge(e) {
    e.preventDefault();
    reorderReviews(true);
}

/*
 Function that is called when user selects dropdown option of ordering shown reviews by upvotes on artist page
 Removes all reviews currently shown on the screen and reloads 10 initial ones using helper function show_more_reviews()
 */
function orderReviewsByUpvotes(e) {
    e.preventDefault();
    reorderReviews(false)
}

/*
Helper function called by orderReviewsBy() functions (above)
Submits ajax request to server to reorder reviews by age/upvote (depends on recent ordered) and specifies whether to show responses (discussion view) based on previous view
 */
function reorderReviews(recent_ordered) {
    $.ajax({
        method: 'GET',
        url: '/users/' + user_id + '/reviews/reorder/' + recent_ordered,
        data: {
            show_responses: show_responses
        }
    });
}

//Function that loads review form on artists page after "update review" button is clicked
function loadReviewForm(){
    $('#review_load_button').hide();
    $('#review_form').show();
}

//Function that sends an ajax request to server w/ content to create a new review
function createReview() {
    var selected_rating = parseInt($('#rating_field').val());
    var comment = $('#review-form-text').val();

    $.ajax({
        type: 'POST',
        url: '/users/' + user_id + '/reviews',
        data: {
            rating: selected_rating,
            comment: comment
        }
    });
}

//Function that sends an ajax request to server w/ content to update an existing review
function updateReview(review_id) {
    var selected_rating = parseInt($('#rating_field').val());
    var comment = $('#review-form-text').val();

    $.ajax({
        type: 'PUT',
        url: '/users/' + user_id + '/reviews/' + review_id,
        data: {
            rating: selected_rating,
            comment: comment
        }
    });
}

/*
Function that creates a response creation form when reply button is clicked
Submit action of this form is to send an ajax request to server w/ content to create a new response
 */
function showReplyForm(node) {
    var review_text_container = node.parentElement.parentElement.parentElement;
    var review = review_text_container.parentElement;
    var review_id = review.getAttribute('data-review_id');
    var wrapper = document.createElement('div');
    wrapper.innerHTML = '<form id="reply_form" class="reply-form"><textarea id="reply"></textarea><input class="btn btn-danger btn-pill reply-form-btn" type="submit" value="Submit"></form>';
    review_text_container.append(wrapper);
    $('#reply_form').submit(function (e) {
        e.preventDefault();
        $.ajax({
            type: 'POST',
            url: '/users/' + user_id + '/reviews/' + review_id + '/responses',
            data: {
                comment: $('#reply').val()
            },
            dataType: 'script'
        })
    });
    node.onclick = null;
}