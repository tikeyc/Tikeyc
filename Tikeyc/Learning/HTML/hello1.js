
function buttonClickAction() {
    
    var isConfirm = confirm("我要玩");
    
    if(isConfirm){
        　　var age = prompt("你多大年龄？");
        　　if(age > 16){
            　　	console.log("游戏开始了！");
            　　	console.log("你在Justin Bieber的演唱会上，你听到了这首歌词'Lace my shoes off， 开始比赛.'");
            　　	console.log("突然， Bieber停止了唱歌，并说道‘谁想和我比赛?’");
            　　	var userAnswer =  prompt("你想在舞台上和Bieber比赛吗？");
            　　	if(userAnswer ==="yes"){
                console.log("你和Bieber 开始比赛，你们不分上下!最终你赢得了比赛！");
                　	         var feedback = prompt("快给这个游戏评个分吧，满分为10分 哦？");
                if(feedback  > 8){
                    console.log("谢谢你，我们应该在下次演唱会接着比赛！");
                }else{
                    console.log("我将继续练习编码来参加比赛！");
                }
            }else{
                console.log("哦，不，Bieber摇摇头，接着唱歌");
            }
            　　
        }else{
            console.log("要好好学习哦！");
            
            alert("年龄限制，需大于16岁");
        }
    }

}



function startGame() {
    var userChoice = prompt("你选择石头、剪刀还是布?");
    if(userChoice == false)userChoice = "石头";
    
    var computerChoice = Math.random();
    if (computerChoice < 0.34) {
        computerChoice = "石头";
    } else if(computerChoice <= 0.67) {
        computerChoice = "布";
    } else {
        computerChoice = "剪刀";
    }

    var result = compere(userChoice, computerChoice);
    alert("用户出：" + userChoice + "     " + "电脑出：" + computerChoice + "     " + result);
    
}

function compere(userChoice, computerChoice) {
    
    var result;
    
    if(userChoice === computerChoice) {

        result = "平局";
    } else if(userChoice == "石头" && computerChoice == "剪刀") {

        result = "用户淫";
    } else if(userChoice == "石头" && computerChoice == "布") {

        result = "电脑淫";
    }
    else if(userChoice == "剪刀" && computerChoice == "石头") {

        result = "电脑淫";
    } else if(userChoice == "剪刀" && computerChoice == "布") {

        result = "用户淫";
    }
    else if(userChoice == "布" && computerChoice == "石头") {

        result = "用户淫";
    } else if(userChoice == "布" && computerChoice == "剪刀") {

        result = "电脑淫";
    }
    
    return result;
}







