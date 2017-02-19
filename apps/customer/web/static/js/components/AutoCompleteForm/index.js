import React, { Component, PropTypes } from 'react';


const propTypes = {

};

class AutoCompleteForm extends Component {

  constructor(props) {
    super(props);
  }

  handleChange(e) {

    e.preventDefault();
    this.props.handleChange(e.target.value, this.props.name);
  }


  render() {
    return(
      <label id={`autoCompleteForm${this.props.name}`}
      <input
        id={`autoCompleteForm${this.props.name}`}
        name={this.props.name}
        type="text"
        value={this.props.value}
        onChange={this.handleChange}
      />
  }
}


AutoCompleteForm.propTypes = propTypes;
export default AutoCompleteForm;