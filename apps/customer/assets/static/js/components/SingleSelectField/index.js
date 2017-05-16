import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Wrapper, Select } from './styles';
import { Label } from 'components';

const propTypes = {
  items: PropTypes.array.isRequired,
  name: PropTypes.string.isRequired,
  currentValue: PropTypes.string.isRequired,
  handleSelect: PropTypes.func.isRequired,
};

class SingleSelectField extends Component {
  constructor(props) {
    super(props);
  }

  getPlaceholderOption() {
    return <option key="disabled" value="" disabled>{this.props.placeholder}</option>;
  }

  getOptions() {
    const options = [];
    const { items } = this.props;
    options.push(this.getPlaceholderOption());
    { items.forEach((item) => {
      options.push(<option key={item} value={item}>{item}</option>);
    }); }
    return options;
  }

  getLabelId() {
    return `${this.props.name}-select-field`;
  }

  render() {
    const { name, currentValue, handleSelect } = this.props;

    return (
      <Wrapper>
        <Label htmlFor={this.getLabelId()} >{name}</Label>
        <Select
          id={this.getLabelId()}
          name={name}
          defaultValue={currentValue}
          onBlur={e => handleSelect(e.target.name, e.target.value)}
        >
          {this.getOptions()}
        </Select>
      </Wrapper>
    );
  }

}

SingleSelectField.propTypes = propTypes;
export default SingleSelectField;
