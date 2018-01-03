



function useJSCallOC(){
    
    var result = window.iOS.test('js传给OC的值1','js传给OC的值2');
    
    alert(result);
}


function useOCCallJS(result) {
    
    alert(result);
    
}
