var friends = {
    
    list: function(obj) {
        for(var prop in obj) {
            console.log(prop);
            alert(prop);
        }
    }
    
};

friends.Tom = {
    name: "Tom",
    number: "(206) 555-5555",
    address: ['USA','NewYork']
};

friends.Jerry = {
    name: "Jerry",
    number: "(010) 555-5555",
    address: ['中国','北京']
};


var search = function(name) {
    for(var prop in friends) {
        if(friends[prop].name === name) {
            return friends[prop];
        }
    }
};

function showListFriends() {
    
    friends.list(friends);
    
    console.log(search("Jerry").number);
    alert(search("Jerry").number);
}



//自定义构造函数
function Person(name,age) {
    this.name = name;
    this.age = age;
}





