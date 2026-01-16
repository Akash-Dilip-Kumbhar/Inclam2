function ClearMail() {

    document.getElementById("name").value = null;
    document.getElementById("email").value = null;
    document.getElementById("msg").value = null;
}

function Reload() {

    setInterval(ClearMail, 1000);
    window.open("/contact.html", "_self");

   
}



function emailValid() {

    var form = document.getElementById("ContactForm");
    var email = document.getElementById("email").value;
    var text = document.getElementById("text");
    var pattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
    const btn = document.getElementById("submit");
    var Message;

    if (email.match(pattern)) {
        form.classList.add("valid");
        form.classList.remove("invalid");
        text.innerHTML = "Your Email Address in Valid.";
        text.style.color = "#00ff00"
        btn.style.display = "block";
    }

    else if (email == "") {
        form.classList.add("valid");
        form.classList.remove("invalid");
        text.innerHTML = " ";
        text.style.color = "#00ff00"

    }
    else {
        form.classList.remove("valid");
        form.classList.add("invalid");
        text.innerHTML = "please enter valid email address";
        text.style.color = "#ff0000"
        btn.style.display = "none";
        $("#email").focus();
    }
}