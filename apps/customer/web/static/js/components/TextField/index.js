import React, { PropTypes, Component } from 'react';

class TextField extends Component {
  constructor(props) {
    super(props);
    this.handleSelect = this.handleSelect.bind(this);
  }

  handleSelect(e) {
    e.preventDefault();
    this.props.handleSelect(e.target.name, e.target.value);
  }

  render() {
    const { name, currentValue, placeholder, tabIndex, autoComplete } = this.props;
    return(
      <div>
        <label
          htmlFor={this.getLabelId()}
        >
          {name}
        </label>
        <input
          id={this.getLabelId()}
          type={name}
          value={currentValue}
          placeholder={placeholder}
          tabIndex={tabIndex}
          autoComplete={autoComplete}
          onClick={this.handleSelect()}
        />
      </div>
    )
  }
}

TextField.propTypes = propTypes;

export default TextField;
