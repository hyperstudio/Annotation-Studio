

//sidebar visibility toggle
var active = false
function openSideMenu(){
  if (active){
    document.getElementById('side-menu').style.width = '0';
    active= false;
    return;
  }
  document.getElementById('side-menu').style.width = '350px';
  active = true
}
function closeSideMenu(){
  document.getElementById('side-menu').style.width = '0';
}

//group join form visibility toggle
function on(){

  //turn off create form
  document.getElementById("create-background").style.display = "none";
  document.getElementById("new-group-form").style.display = "none";

  document.getElementById("join-form").style.display = "block";
  document.getElementById("join-background").style.display = "block";
}

function off(){
  document.getElementById("join-form").style.display = "none";
  document.getElementById("join-background").style.display = "none";
}

//autocomplete for joining groups?
// $(document.getElementById("groupName")).autocomplete({
//   source: <%= raw(Group.all.pluck(:name)) %>
// })


//create group form visibility toggle. 
function show(){
  off(); //turn off join form
  document.getElementById("create-background").style.display = "block";
  document.getElementById("new-group-form").style.display = "block";
  
}

function hide(){
  document.getElementById("create-background").style.display = "none";
  document.getElementById("new-group-form").style.display = "none";
  
}