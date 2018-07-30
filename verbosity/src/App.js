import React, { Component } from 'react';
import TextPad from './components/textpad'
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <h1 className="App-title">Verbosity</h1>
        </header>
        <TextPad/>
      </div>
    );
  }
}

export default App;
