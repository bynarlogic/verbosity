import React, { Component } from 'react';
import axios from 'axios';



class TextPad extends Component {


  constructor(props) {
    super(props);
    this.state = { sentence: "",verbose: "A verbose version of this.", verbose_level: 1, pending_request: false };

  }

  render() {
    var textDisplay = "Some Text";

    if (this.state.pending_request) {
      textDisplay = "pending..."
    } else {
      textDisplay = this.state.verbose
    }

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
          {textDisplay}
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
    const URL = `http://localhost:4567/sentence/${this.state.sentence}/level/${this.state.verbose_level}`
    this.setState({verbose_level: level, pending_request: true})
    axios.get(URL).then(response => this.setState({verbose: response.data, pending_request: false}) )
    this.setState({sentence: this.state.sentence})
  }

  onInputChange(sentence) {
    this.setState({verbose_level: 1})
    const URL = `http://localhost:4567/sentence/${sentence}/level/${this.state.verbose_level}`
    axios.get(URL).then(response => this.setState({verbose: response.data}) )
    this.setState({sentence})
  }
}

export default TextPad
