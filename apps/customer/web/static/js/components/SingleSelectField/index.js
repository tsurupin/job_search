import React, { Component, PropTypes } from 'react';


const propTypes = {
  items: PropTypes.array.isRequired,
  name: PropTypes.string.isRequired,
  currentValue: PropTypes.string.isRequired,
  handleSelect: PropTypes.func.isRequired
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
    const { items } = this.props;
    options.push(this.getPlaceholderOption());
    {items.forEach(item => {
      options.push(<option key={item} value={item}>{item}</option>);
    })}
    return options;
  }

  render() {
    const { name, currentValue, handleSelect } = this.props;

    return(
      <select
        name={name}
        defaultValue={currentValue}
        onBlur={e => handleSelect(e.target.name, e.target.value)}
      >
        {this.getOptions()}
      </select>
    )
  }

}

SingleSelectField.propTypes = propTypes;
export default SingleSelectField;