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
import _ from 'lodash';
import { table } from 'table';

$(function() {
  $('.sell-stock').click((ev) => {
    let sell_data = {
      trade_id: $(ev.target).data('trade-id'),
      account_id: $('#invest-submit-dealer').data('account-id'),
      date: $('#sell-date').val()
    }

    $.ajax("/sell_stock", {
      method: "post",
      dataType: "json",
      beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-Token", token);
      },
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(sell_data),
      success: (resp) => {
        location.reload();
      }
    });
  });
});

$(function() {
  $('#invest-submit-dealer').click((ev) => {
    let invest_data = {
      trade_order: {
        trade_id: "" + _.random(999999999),
        stock_symbol: $("#invest-symbol").val(),
        num_of_share: $("#invest-shares").val(),
        date: $("#invest-date").val(),
        account_id: $(ev.target).data('account-id'),
        type: "dealer",
        result: "success"
      }
    }

    $.ajax("/invest_dealer", {
      method: "post",
      dataType: "json",
      beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-Token", token);
      },
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(invest_data),
      success: (resp) => {
        location.reload();
      },
      error: (resp) => {
        $("#invest-status").text("Failed to process investment");
      }
    });
  });
});

$(function() {
  $('#stock-submit').click((ev) => {
    let ticker_map = {
      ticker_val: $('#stock-input').val()
    }

    $.ajax("/lookup_stock", {
      method: "post",
      dataType: "json",
      beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-Token", token);
      },
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(ticker_map),
      success: (resp) => {
        let header_text = "Viewing Stock info for " + resp.info.company_name + "\n\n"
          + "Ticker Symbol: " + resp.info.symbol + "\n"
          + "Subsidiaries: " + resp.info.subsidiaries + "\n"
          + "10-k: " + resp.info["10-k"] + "\n"
          + "News: " + resp.info.news + "\n";
        $('#stock-header').text(header_text);
        $('#stock-body').text(table(resp.data));
      },
      error: (resp) => {
        $('#stock-body').text("Please enter a valid NASDAQ ticker symbol");
      }
    });
  });
});

$(function() {
  $('#dealer-register').click((ev) => {
    let register_data = {
      account: {
        account_id: "" + _.random(999999999),
        user_name: $('#dealer-username').val(),
        password: $('#dealer-password').val(),
        first_name: $('#dealer-first-name').val(),
        last_name: $('#dealer-last-name').val(),
        address: $('#dealer-address').val(),
        email: $('#dealer-email').val(),
        tax_payer_No: $('#dealer-tpn').val()
      }
    }

    $.ajax("/register_dealer", {
      method: "post",
      dataType: "json",
      beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-Token", token);
      },
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(register_data),
      success: (resp) => {
        $('#dealer-status').text("Successfully registered account");
      },
      error: (resp) => {
        $('#dealer-status').text("Account registration failed");
      }
    });
  });
});

$(function() {
  $('#broker-register').click((ev) => {
    let register_data = {
      account: {
        account_id: "" + _.random(999999999),
        user_name: $('#broker-username').val(),
        password: $('#broker-password').val(),
        first_name: $('#broker-first-name').val(),
        last_name: $('#broker-last-name').val(),
        address: $('#broker-address').val(),
        ssn: $('#broker-ssn').val(),
        bonus: $('#broker-bonus').val()
      }
    }

    $.ajax("/register_broker", {
      method: "post",
      dataType: "json",
      beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-Token", token);
      },
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(register_data),
      success: (resp) => {
        $('#broker-status').text("Successfully registered account");
      },
      error: (resp) => {
        $('#broker-status').text("Account registration failed");
      }
    });
  });
});

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
