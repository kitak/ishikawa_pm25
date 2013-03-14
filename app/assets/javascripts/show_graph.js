$(document).ready(function () {
  $("#show_graph").click(function (e) {
    e.preventDefault();
    e.stopPropagation();

    var month = +$("#month").val();
    var day = +$("#day").val();
    console.log(month);
    console.log(day);
    var $img = $("<img>").attr("src", "./"+month+"/"+day+".png");
    $("#graph_area").html($img);
  });
});
