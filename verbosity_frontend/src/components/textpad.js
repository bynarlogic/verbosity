import React, { Component } from 'react';
import axios from 'axios';

const HOST = process.env.REACT_APP_HOST;


class TextPad extends Component {


  constructor(props) {
    super(props);
    this.state = { sentence: "",verbose: "A verbose version of this.", verbose_level: 1, pending_request: false };

  }

  componentDidUpdate() {
    if (this.state.pending_request) {
      this.makeRequest()
    }
  }

  render() {

    return(
      <div>
        <form>
          <textarea
            rows="5"
            placeholder="Enter a sentence"
            value={this.state.sentence}
            onChange={event => this.onInputChange(event.target.value,1000)}
          />
        </form>
        <p>
          {this.displayText()}
        </p>
        <button
          onClick={event => this.onVerboseClick(this.state.verbose_level)}
        >
          Make Verbose
        </button>
      </div>
    )
  }

  onVerboseClick(level) {
    level++
    this.setState({verbose_level: level, pending_request: true})
  }

  onInputChange(sentence) {
    this.setState({verbose_level: 1,pending_request: true})
    this.setState({sentence})
  }

  makeRequest() {
    const URL = `http://${HOST}:4567/sentence/${this.state.sentence}/level/${this.state.verbose_level}`
    axios.get(URL).then(response => this.setState({verbose: response.data, pending_request: false}) )
  }

  displayText() {
    if (this.state.pending_request && this.state.sentence != "") {
      return "pending..."
    } else if(this.state.sentence != "" && !this.state.pending_request){
      return this.state.verbose
    } else {
      return "A verbose version of this."
    }
  }


}

export default TextPad
