import React,{useState} from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import { createStore } from '../node_modules/redux'



class Square extends React.Component {
    render() {
      return (
        <button className="square">
          {/* TODO */}
        </button>
      );
    }
  }
  
  class Board extends React.Component {
    renderSquare(i) {
      return <Square />;
    }
  
    render() {
      const status = 'Next player: X';
  
      return (
        <div>
          <div className="status">{status}</div>
          <div className="board-row">
            {this.renderSquare(0)}
            {this.renderSquare(1)}
            {this.renderSquare(2)}
          </div>
          <div className="board-row">
            {this.renderSquare(3)}
            {this.renderSquare(4)}
            {this.renderSquare(5)}
          </div>
          <div className="board-row">
            {this.renderSquare(6)}
            {this.renderSquare(7)}
            {this.renderSquare(8)}
          </div>
        </div>
      );
    }
  }
  
  class Game extends React.Component {
    render() {
      return (
        <div className="game">
          <div className="game-board">
            <Board />
          </div>
          <div className="game-info">
            <div>{/* status */}</div>
            <ol>{/* TODO */}</ol>
          </div>
        </div>
      );
    }
  }
  
  // ========================================

function Example (){
  var [count , setCount] = useState(10)

  // 解构
  // var o = {p: 42, q: true};
  // const {p,q} = o
  // alert(p)

  // 重新起名和变量赋值
  // var {a:aa = 10, b:bb = 30} = {a:2333}
  // alert(bb)// bb:30
  // alert(aa)// aa:2333 


  // 给定默认值
  // let chartSetting = ({size = 'big',cords = {x:0,y:0},radius = 26} = {}) =>{
  //   console.log(size,cords,radius)
  // }

  // chartSetting({size:'size change',cords:{x:3,y:6}})


  // const metadata = {
  //   title: 'Scratchpad',
  //   translations: [
  //     {
  //       locale: 'de',
  //       localization_tags: [],
  //       last_edit: '2014-04-14T08:43:37',
  //       url: '/de/docs/Tools/Scratchpad',
  //       title: 'JavaScript-Umgebung'
  //     }
  //   ],
  //   url: '/en-US/docs/Tools/Scratchpad'
  // };

    
  // console.log(metadata.title)
  // console.log(metadata.translations[0].title)

  // console.log('br')

  // let {
  //   title:newTitle,
  //   translations:[
  //     {
  //       title:subtitleChange
  //     }
  //   ]
  // } = metadata
  


  // console.log(newTitle)
  // console.log(subtitleChange)


  // var people = [
  //   {
  //     name: 'Mike Smith',
  //     family: {
  //       mother: 'Jane Smith',
  //       father: 'Harry Smith',
  //       sister: 'Samantha Smith'
  //     },
  //     age: 35
  //   },
  //   {
  //     name: 'Tom Jones',
  //     family: {
  //       mother: 'Norah Jones',
  //       father: 'Richard Jones',
  //       brother: 'Howard Jones'
  //     },
  //     age: 25
  //   }
  // ];


  // for (const {name:n,family:{father:f}} of people) {
  //   console.log('name' + n + ' farther ' + f)
  // }



  // var user = {
  //   id: 42,
  //   displayName: "jdoe",
  //   fullName: {
  //       firstName: "John",
  //       lastName: "Doe"
  //   }
  // };

  
  // // 解构  获取 id, displayName , firstName

  // let userID = ({id})=>id

  // let whopsPeople = ({displayName:name,fullName:{firstName:first}}) =>{
  //   console.log('id=' + userID(user) + ' displayName=' + name + ' name=' + first)
  // }

  //   whopsPeople(user)


  // redux 简单使用


const initStore = (state = 0,action) =>{
  switch (action.type) {
    case 'increase':
      return state + 1
      break
    case 'decrement':
      return state -1
      break;
    default:
      break;
  }
}


const store = createStore(initStore)


store.subscribe(() =>{
  let div = document.getElementById('count')
  div.innerHTML = store.getState()
})


const updateAction = {
  type:'increase',
  payload:'parma+1'
}

const decrementAction = {
  type : 'decrement',
  payload : 'parma-1'
}

store.subscribe(() => console.log(store.getState()))


const updateCount = (type) => {
  if (type === 'increase'){
    store.dispatch(updateAction)
  }else{
    store.dispatch(decrementAction)  
  }
  
}


  return (
    <div>
        <p id='count'></p>
        <p >you click {count+1} times</p>
        <button id='button' onClick={()=>updateCount('increase')}>🔘+</button>
        <button id='button' onClick={()=>updateCount('decrement')}>🔘-</button>

        <button onClick={()=>setCount(count + 1)}>🔘</button>
    </div>
  )
}

// class Example extends React.Component{
//   constructor(props){
//     super(props)
//     this.state = {
//       count:0
//     }
//   }
//   render(){
//     return(
//       <div>
//         <p>you click {this.state.count} times</p>
//         <button onClick={()=>this.setState({
//               count:this.state.count+1
//           })
//         }>🔘</button>
//       </div>
//     )
//   }
// }
  


  
  ReactDOM.render(
    // <Game />,
    <Example></Example>,
    document.getElementById('root')
  );
  