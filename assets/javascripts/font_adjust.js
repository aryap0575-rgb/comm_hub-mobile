window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
    window.flutter_inappwebview.callHandler('increaseFontSize').then(function(result) {
        funIcreaseFontSize();
    });
    window.flutter_inappwebview.callHandler('decreaseFontSize').then(function(result) {
        funDecreaseFontSize();
    });
});



function funIcreaseFontSize(){
    try {
        var getElement = document.body.getElementsByTagName("*");
        [...getElement].forEach((elem) =>{
            var curr = getComputedStyle(elem).fontSize;
            console.log(curr);
            if(curr != 0 && curr != "" && curr != undefined){
                var float_curr = parseFloat(curr);
                float_curr += 1;
                elem.style.fontSize = float_curr + "px"
            }
        });
      }
      catch(err) {
        console.log(err);
      }
    
    // Send data to flutter 
    window.flutter_inappwebview
    .callHandler('adjustmentCtrl', true);
};

function funDecreaseFontSize(){
    try {
        var getElement = document.body.getElementsByTagName("*");
        [...getElement].forEach((elem) =>{
            var curr = getComputedStyle(elem).fontSize;
            console.log(curr);
            if(curr != 0 && curr != "" && curr != undefined){
                var float_curr = parseFloat(curr);
                float_curr -= 1;
                elem.style.fontSize = float_curr + "px"
            }
        });
    }
    catch(err) {
    console.log(err);
    }
    // Send data to flutter
    window.flutter_inappwebview
    .callHandler('adjustmentCtrl', true);
}

  