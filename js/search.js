
function openpage() {
    var a = document.getElementById("search").value;
    var x = a.toLowerCase();


    if (x === "home") {
        window.open("/index.html", "_self");
    }
  
    if (x === "new") {
        window.open("NewRaaga.html", "_self");
    }

    if (x === "artist") {
        window.open("/artists.html", "_self");
    }

    if (x === "raaga") {
        window.open("/AllRaga.html", "_self");
    }

    if (x === "about") {
        window.open("/about.html", "_self");
    }

    if (x === "profile") {
        window.open("/profile.html", "_self");
    }

    if (x === "ankita") {

        window.open("/Artist_AnkitaTambe.html", "_self");
    }
    if (x === "tambe") {
        window.open("/Artist_AnkitaTambe.html", "_self");
    }

    if (x === "bhagyesh") {
        window.open("/Artist_BhagyeshMarathe.html", "_self");
    }
    if (x === "marathe") {
        window.open("/Artist_BhagyeshMarathe.html", "_self");
    }

    if (x === "chinmayee") {
        window.open("/Artist_ChinmayeeAthale.html", "_self");
    }
    if (x === "athale") {
        window.open("/Artist_ChinmayeeAthale.html", "_self");
    }

    if (x === "hrishikesh") {
        window.open("/Artist_HrishikeshBadve.html", "_self");
    }
    if (x === "badve") {
        window.open("/Artist_HrishikeshBadve.html", "_self");
    }

    if (x === "komal") {
        window.open("/Artist_KomalSane.html", "_self");
    }
    if (x === "sane") {
        window.open("/Artist_KomalSane.html", "_self");
    }

    if (x === "mahesh") {
        window.open("/Artist_MaheshKale.html", "_self");
    }
    if (x === "kale") {
        window.open("/Artist_MaheshKale.html", "_self");
    }

    if (x === "meghana") {
        window.open("/Artist_MeghanaKhandkar.html", "_self");
    }
    if (x === "khadkar") {
        window.open("/Artist_MeghanaKhandkar.html", "_self");
    }

    if (x === "mrunmayee") {

        window.open("/Artist_MrunmayeePhatak.html", "_self");
    }
    if (x === "phatak") {
        window.open("/Artist_MrunmayeePhatak.html", "_self");
    }

    if (x === "mukul") {
        window.open("/Artist_MukulKulkarni.html", "_self");
    }
    if (x === "kulkarni") {
        window.open("/Artist_MukulKulkarni.html", "_self");
    }

    if (x === "nagesh") {
        window.open("/Artist_NageshAdgaonkar.html", "_self");
    }
    if (x === "adgaonkar") {
        window.open("/Artist_NageshAdgaonkar.html"), "_self";
    }

    if (x === "rajiv") {
        window.open("/Artist_RajivTambe.html", "_self");
    }
    if (x === "tambe") {
        window.open("/Artist_RajivTambe.html", "_self");
    }

    if (x === "saurabh") {
        window.open("/Artist_SaurabhKadgaonkar.html", "_self");
    }
    if (x === "kadgaonkar") {
        window.open("/Artist_SaurabhKadgaonkar.html", "_self");
    }

    if (x === "shruti") {
        window.open("/Artist_ShrutiVishwakarma.html", "_self");
    }
    if (x === "vishwakarma") {
        window.open("/Artist_ShrutiVishwakarma.html", "_self");
    }

    if (x === "suranjan") {
        window.open("/Artist_SuranjanKhandalkar.html", "_self");
    }
    if (x === "khandalkar") {
        window.open("/Artist_SuranjanKhandalkar.html", "_self");
    }
}

function hitcount() {
document.getElementById("display").innerHTML=count();
}
 
var count=(function(){
    var counter=0;
    return function (){return counter+=1;}
})();
