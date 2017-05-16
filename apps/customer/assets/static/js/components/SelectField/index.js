import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Wrapper } from './styles';

const propTypes = {
  value: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  tabIndex: PropTypes.number.isRequired,
  options: PropTypes.object,
  handleChange: PropTypes.func.isRequired,
};


class SelectField extends Component {
  constructor(props) {
    super(props);
  }

  getOptions() {
    const options = [];
    for (const [k, v] of Object.entries(this.props.options)) {
      options.push(<option key={k} value={v}>{k}</option>);
    }
    return options;
  }

  render() {
    const { value, name, tabIndex, handleChange } = this.props;
    return (
      <Wrapper
        defaultValue={value}
        name={name}
        tabIndex={tabIndex}
        onBlur={event => handleChange(name, event.target.value)}
      >
        {this.getOptions()}
      </Wrapper>
    );
  }
}

SelectField.propTypes = propTypes;
export default SelectField;
