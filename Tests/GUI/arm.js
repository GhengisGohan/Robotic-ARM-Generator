var xmlns = "http://www.w3.org/2000/svg", select = function (s) {
      return document.querySelector(s);
    },  container = select('.container'),
        base_bone = select('.base_bone'),
        base_servo = select('.base_servo'),
        base_servo_circle = select('.base_servo_circle'),
        base_servo_rect = select('.base_servo_rect'),
        humerus_bone = select('.humerus_bone'),
        humerus_servo = select('.humerus_servo'),
        humerus_servo_circle = select('.humerus_servo_circle'),
        ulna_bone = select('.ulna_bone'),
        ulna_servo = select('.ulna_servo'),
        ulna_servo_circle = select('.ulna_servo_circle'),
        wrist_bone = select('.wrist_bone'),
        wrist_servo = select('.wrist_servo'),
        wrist_servo_circle = select('.wrist_servo_circle'),
        ball = select('.ball');

console.log(ball);

// Controls
 var CONTROLS = function() {
   this.wrist = 360;
   this.wristLen = 65;
   this.no_fill = false;
 };


ctr = new CONTROLS();
ui = new dat.GUI();
var onWrist = ui.add(ctr, 'wrist', 0, 360);
var onWristLen = ui.add(ctr, 'wristLen', 0, 200);
var onNoFill = ui.add(ctr, 'no_fill');

onWrist.onFinishChange(function(value) {
  TweenMax.to(wrist_bone, 1, {rotation:value, transformOrigin:"50% 0%"});
})

onWristLen.onFinishChange(function(value) {
   TweenMax.set(wrist_bone, {
      attr:{
        height:value
      }
    })
})

onNoFill.onFinishChange(function(value) {
  // Fires when a controller loses focus.
  CONTROLS.no_fill = value;

  if (CONTROLS.no_fill == false) {

    // Change all svg parts to no fill
    changeColor(base_bone, "#41e841");
    changeColor(base_servo, "#484848");
    changeColor(base_servo_circle, "#484848");
    changeColor(base_servo_rect, "white");
    changeColor(humerus_bone, "#41e841");
    changeColor(humerus_servo, "#484848");
    changeColor(humerus_servo_circle, "#484848");
    changeColor(ulna_bone, "#41e841");
    changeColor(ulna_servo, "#484848");
    changeColor(ulna_servo_circle, "#484848");
    changeColor(wrist_bone, "#41e841");
    changeColor(wrist_servo, "#484848");
    changeColor(wrist_servo_circle, "#484848");
    changeColor(ball, "red");

    console.log("false");
  } else {

    // Change all svg parts to no fill
    changeColor(base_bone, "none");
    changeColor(base_servo, "none");
    changeColor(base_servo_circle, "none");
    changeColor(base_servo_rect, "none");
    changeColor(humerus_bone, "none");
    changeColor(humerus_servo, "none");
    changeColor(humerus_servo_circle, "none");
    changeColor(ulna_bone, "none");
    changeColor(ulna_servo, "none");
    changeColor(ulna_servo_circle, "none");
    changeColor(wrist_bone, "none");
    changeColor(wrist_servo, "none");
    changeColor(wrist_servo_circle, "none");
    changeColor(ball, "none");

    console.log("true");
  }

});

function changeColor(cont, color) {
    TweenMax.set(cont, {
      attr:{},
      fill:(color)
    })
}


//var pincerGroupWidth = 174;
//var shoulderFollower = getFollower(shoulderGroup, '#6A3000')
//var forearmFollower = getFollower(forearmGroup, 'red')
//var pincerFollower = getFollower(forearmGroup, 'purple');
//
//function getFollower(cont, color){
//
//  var c = document.createElementNS(xmlns, 'circle');
//  cont.appendChild(c);
//  TweenMax.set(c, {
//    attr:{
//      r:10,
//      cx:0,
//      cy:0
//    },
//    transformOrigin:'50% 50%',
//    fill:(!color) ? 'rgba(75,75,75,1)' : color
//
//  })
//
//  return c
//}


//center the SVG image
//TweenMax.set(container, {
//  position:'absolute',
//  top:'50%',
//  left:'50%',
//  xPercent:-50,
//  yPercent:-50
//})

//TweenMax.set(shoulder, {
//  svgOrigin:'157.5 502.1'
//})
//
//TweenMax.set([forearm, pincerGroup,], {
//  transformOrigin:'50% 0%'
//})

/*

function update(){

  TweenMax.set(shoulderJoint, {
    attr:{
      cx:shoulderFollower._gsTransform.x,
      cy:shoulderFollower._gsTransform.y
    }
  })
  TweenMax.set(arm, {
    attr:{
      x1:forearmFollower._gsTransform.x,
      y1:forearmFollower._gsTransform.y,               x2:shoulderFollower._gsTransform.x,
      y2:shoulderFollower._gsTransform.y
    }
  })

TweenMax.set(elbowJoint, {
  attr:{
      cx:forearmFollower._gsTransform.x,
      cy:forearmFollower._gsTransform.y,
  }
})
 TweenMax.set(pincerJoint, {
  attr:{
      cx:pincerFollower._gsTransform.x,
      cy:pincerFollower._gsTransform.y
  }
})

 TweenMax.set(pincerGroup, {
   x:pincerFollower._gsTransform.x - (pincerGroupWidth/2),
   y:pincerFollower._gsTransform.y
 })



}

var wheelTimeline = new TimelineMax({repeat:-1});
wheelTimeline.timeScale(1.2)
wheelTimeline.to([wheelL, wheelR], 4, {
  rotation:-360,
  transformOrigin:'50% 50%',
  ease:Linear.easeNone
})
var mechTimeline = new TimelineMax({repeat:-1, onUpdate:update});
mechTimeline.timeScale(1.2)
mechTimeline.set(shoulder, {
  rotation:-23
})
.set(pincerL, {
  rotation:-5,
  transformOrigin:'100% 0%'
})
.set(pincerR, {
  rotation:5,
  transformOrigin:'0% 0%'
})
.to(forearm, 1, {
  attr:{
    y1:'-=50',
    y2:'-=50'
  },
  ease:Elastic.easeOut

})
.to(ball, 1, {
  attr:{
    //cy:'-=50'
  },
  y:'-=50',
  ease:Elastic.easeOut
}, '-=1')
.to(forearm, 1, {
  attr:{
    //x1:300,
    x1:'+=200',
    x2:'+=200'
  },
  //ease:Elastic.easeOut
  ease:Power2.easeInOut

})
.to(ball, 1, {
  attr:{
    //cx:'+=200'
  },
  x:'+=200',
  ease:Power2.easeInOut
}, '-=1')
.to(forearm, 1, {
  attr:{
    //x1:300,
    y1:'+=50',
    y2:'+=50'
  },
  //ease:Elastic.easeOut
  ease:Power2.easeInOut

})
.to(ball, 1, {
  attr:{
    //cy:'+=50'
  },
  y:'+=50',
  ease:Power2.easeInOut
}, '-=1')
.to(ball, 6, {
  attr:{
    //cx:'-=200'
  },
  x:'-=200',
  ease:Linear.easeNone
})
.to(pincerL, 0.5, {
  rotation:0,
  transformOrigin:'100% 0%'
}, '-=6.1')
.to(pincerR, 0.5, {
  rotation:0,
  transformOrigin:'0% 0%'
}, '-=6.1')
.to(forearm, 1, {
  attr:{
    //x1:300,
    y1:'-=50',
    y2:'-=50'
  },
  //ease:Elastic.easeOut
  ease:Power2.easeInOut

},'-=5.9')
.to(forearm, 3, {
  attr:{
    //x1:300,
    x1:'-=200',
    x2:'-=200'
  },
  //ease:Elastic.easeOut
  ease:Power2.easeInOut

}, '-=5.5')
.to(pincerGroup, 2, {
  rotation:-30,

  ease:Power1.easeIn
},'-=5.7')
 .to(pincerGroup, 1, {
  rotation:0,

  ease:Power2.easeInOut
},'-=3.5')
 .to(forearm, 1, {
  attr:{
    //x1:300,
    y1:'+=50',
    y2:'+=50'
  },
  //ease:Elastic.easeOut.config(1, 0.7)
  ease:Power2.easeInOut

},'-=1')

.to(forearm, 1, {
  rotation:-23,
  //ease:Elastic.easeOut.config(1, 0.7)
  ease:Power1.easeInOut
},'-=5')
.to(forearm, 1, {
  rotation:0,
  //ease:Elastic.easeOut.config(1, 0.7)
  ease:Power1.easeInOut
},'-=4')
.to(shoulder, 2, {
  rotation:0,
  ease:Power4.easeInOut
},'-=8.5')
.to(shoulder, 2, {
  rotation:-23,
  ease:Power1.easeInOut
},'-=5')
*/
