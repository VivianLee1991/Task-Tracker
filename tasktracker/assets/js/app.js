// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function update_manage_buttons() {
  $('.manage-button').each( (_, bb) => {
    let user_id = $(bb).data('user-id');
    let manage = $(bb).data('manage');
    if (manage != "") {
      $(bb).text("Unmanage");
    }
    else {
      $(bb).text("Manage");
    }
  });
}

function update_time_buttons() {
  $('.time_button').each( (_, bb) => {
    let time_id = $(bb).data('time-id');
    if (time_id != "") {
      $(bb).text("Stop Working!");
    }
    else {
      $(bb).text("Start Working!");
    }
  })
}

function set_manage_button(user_id, value) {
  $('.manage-button').each( (_, bb) => {
    if (user_id == $(bb).data('user-id')) {
      $(bb).data('manage', value);
    }
  });
  update_manage_buttons();
}

function set_time_button(task_id, value) {
  $('.time-button').each( (_, bb) => {
    if (task_id == $(bb).data('task-id')) {
      $(bb).data('manage-id', value);
    }
  });
  update_time_buttons();
}


function manage(user_id) {
  let text = JSON.stringify({
    manage: {
      manager_id: current_user_id,
      member_id: user_id
    },
  });

  $.ajax(manage_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_manage_button(user_id, resp.data.id); },
  });
}

function unmanage(user_id, manage_id) {
  $.ajax(manage_path + "/" + manage_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => { set_manage_button(user_id, ""); },
  });
}


function start_working(task_id, cur_time) {
  let text = JSON.stringify({
    timeblock: {
      start: cur_time,
      end: new Date(0),
      task_id: task_id
    },
  });

  $.ajax(timeblock_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_time_button(task_id, resp.data.id); },
  });
}

function stop_working(task_id, time_id, cur_time) {
  let text = JSON.stringify({
    timeblock: {
      end: cur_time,
    },
  });

  $.ajax(timeblock_path + "/" + time_id, {
    method: "patch",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_time_button(task_id, ""); },
  });
}

function manage_click(ev) {
  let btn = $(ev.target);
  let user_id = btn.data('user-id');
  let manage_id = btn.data('manage');

  if (manage_id != "") {
    unmanage(user_id, manage_id);
  } else {
    manage(user_id);
  }
}

function time_click(ev) {
  let btn = $(ev.target);
  let task_id = btn.data('task-id');
  let time_id = btn.data('time-id');
  const now = new Date();

  if (time_id == "") {
    start_working(task_id, now);
  }
  else {
    stop_working(task_id, time_id, now);
  }
}


function init_manage() {
  if (! $('.manage-button')) {
    return;
  }
  $('.manage-button').click(manage_click);
  update_manage_buttons();
}

function init_time() {
  if (! $('.time-button')) {
    return;
  }
  $('.time-button').click(time_click);
  update_time_buttons();
}

function init_all() {
  init_manage();
  init_time();
}

$(init_all);
