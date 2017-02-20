import React, { Component, PropTypes } from 'react';


const propTypes = {

};

class SingleSelectField extends Component {
  constructor(props) {
    super(props);

  }

  getPlaceholderOption() {
    return <option key='disabled' value='' disabled>{this.props.placeholder}</option>
  }


  getOptions() {
    let options = [];
    options.push(this.getPlaceholderOption());
    {this.props.items.forEach(item => {
      options.push(<option key={item} value={item}>{item}</option>);
    })}
    return options;
  }

  handleSelect(e) {
    this.props.handleSelect(e.target.name, e.target.value);
  }

  render() {
    const { name, currentValue } = this.props;

    return(
      <select
        name={name}
        defaultValue={currentValue}
        onClick={this.handleSelect()}
      >
        {this.getOptions()}
      </select>
    )
  }

}

SingleSelectField.propTypes = propTypes;
export default SingleSelectField;