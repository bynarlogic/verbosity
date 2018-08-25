import React, { Component } from 'react';
import Home from './components/home';
import {BrowserRouter, Route} from 'react-router-dom';
import './App.css';

class App extends Component {
  render() {
    return (
        <BrowserRouter basename='/verbosity'>
          <Home />
        </BrowserRouter>
    );
  }
}

export default App;
