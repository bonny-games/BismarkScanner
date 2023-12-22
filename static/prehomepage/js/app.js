function isWebp(){
    function testWebp(callback) {
        let webP = new Image();
        webP.onload = webP.onerror = function (){
            callback(webP.height == 2);
        };
        webP.src = "data:image/webp;base64,UklGRjoAAABXRUJQVlA4IC4AAACyAgCdASoCAAIALmk0mk0iIiIiIgBoSygABc6WWgAA/veff/0PP8bA//LwYAAA";

    }
    testWebp(function (support){
        let className = support = true ? "webp" : "no-webp";
        document.documentElement.classList.add(className);
    })
}

isWebp();



const btnBurger = document.querySelector(".header__burger");
const burger = document.querySelector(".burger__open");

btnBurger.addEventListener("click", item =>{
    btnBurger.classList.toggle("close");
});



btnBurger.addEventListener("click", ()=>{
    document.querySelector("body").classList.toggle("scrollNone");
    burger.classList.toggle("burger__open-active");
    btnBurger.classList.remove("header__burger_close");
});

let header = document.querySelector("header");

window.addEventListener("scroll", ()=>{
    if(scrollY>10){
        header.classList.add("header__scroll");
    }else{
        header.classList.remove("header__scroll");
    }
})


////////////modal
let btnModal = document.querySelectorAll(".modalActive");
const modalWr = document.querySelector(".modal__wr");
const modalContent = document.querySelector(".modal__body");


btnModal.forEach(item=>{
    item.addEventListener("click", ()=>{
        modalWr.classList.add("modal__wr-active");
        modalContent.classList.add("modal__body-open");
    });
});


modalWr.addEventListener("click", function(event){
    modalWr.classList.remove("modal__wr-active");
    modalContent.classList.remove("modal__body-open");
})


const video = document.querySelector('#initial');


setTimeout(()=>{
    video.playbackRate = 0.6;

    video.addEventListener('ended', function() {
        video.currentTime = 0;
        video.play();
    });

    video.play();


}, 100)

function addBalanceData() {
    let balanceData = document.getElementsByClassName('balance-item');
    for (let i = 0; i < balanceData.length; i++) {
        let data =  Math.floor(Math.random() * 999) + 1;
        balanceData[i].textContent = data.toString();
    }
}

function addHackData() {
    let balanceData = document.getElementsByClassName('hack-item');
    for (let i = 0; i < balanceData.length; i++) {
        let data =  Math.floor(Math.random() * 3) + 1;
        balanceData[i].textContent = data.toString();
    }
}

function changeNumber(count, e, t, inc) {
    let i = 1;

    function updateNumber() {
        if (i <= count) {
            e.innerText = i;
            i = i + inc;
            setTimeout(updateNumber, t); // Затримка у мілісекундах (тут 1000 мілісекунд = 1 секунда)
        }
    }

    updateNumber();
}

// Приклад виклику функції зміни чисел до 6 з інтервалом в 1 секунду
changeNumber(200,document.getElementById('i1'), 50, 6);
changeNumber(14,document.getElementById('i2'), 150, 1);
changeNumber(6,document.getElementById('i3'), 200, 1);
addBalanceData();
addHackData();


