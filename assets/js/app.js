// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import "bootstrap";


$(function () {
  $('#balancebutton').click((ev) => {
    let funds = $('#balanceinput').val();

    let addfunds_data = {
      amount: funds
    };

    $.ajax("/addfunds", {
      method: "post",
      dataType: "json",
      beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-Token", token);
      },
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(addfunds_data),
      success: (resp) => {
        $('#balancetext').text("Account Balance: " + resp.account_balance);
      }
    });
  });
});
