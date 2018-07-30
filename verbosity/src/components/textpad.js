import React, { Component } from 'react';

class TextPad extends Component {
  render() {
    return(
      <div className="form-group">
        <form>
          <textarea rows="5" width="100%" placeholder="Enter a sentence"/>
        </form>
      </div>
    )
  }
}

export default TextPad
