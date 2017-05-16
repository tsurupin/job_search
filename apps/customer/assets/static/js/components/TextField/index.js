import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Wrapper, Input } from './styles';
import { Label } from 'components';

const propTypes = {
  needLabel: PropTypes.bool.isRequired,
  name: PropTypes.string.isRequired,
  currentValue: PropTypes.string.isRequired,
  placeholder: PropTypes.string.isRequired,
  tabIndex: PropTypes.number.isRequired,
  autoComplete: PropTypes.string.isRequired,
  handleSelect: PropTypes.func.isRequired,
};

const defaultProps = {
  needLabel: true,
};


class TextField extends Component {
  constructor(props) {
    super(props);
    const { currentValue } = props;
    this.state = { currentValue };
    this.handleSelect = this.handleSelect.bind(this);
  }

  componentWillReceiveProps(newProps) {
    if (this.state.currentValue === newProps.currentValue) return;
    const { currentValue } = newProps;
    this.setState({ currentValue });
  }

  handleSelect(e) {
    if (e.key !== 'Enter') return;
    this.props.handleSelect(e.target.name, e.target.value);
  }

  getLabelId() {
    return `${this.props.name}-text-field`;
  }

  renderLabel() {
    if (!this.props.needLabel) return;
    return (<label htmlFor={this.getLabelId()} className="label">{this.props.name}</label>);
  }


  render() {
    const {
      name,
      placeholder,
      tabIndex,
      autoComplete,
    } = this.props;
    const { currentValue } = this.state;

    return (
      <Wrapper>
        {this.renderLabel()}
        <Input
          id={this.getLabelId()}
          type="text"
          name={name}
          value={currentValue}
          placeholder={placeholder}
          tabIndex={tabIndex}
          autoComplete={autoComplete}
          onChange={e => this.setState({ currentValue: e.target.value })}
          onKeyPress={this.handleSelect}
        />
      </Wrapper>
    );
  }
}

TextField.propTypes = propTypes;
TextField.defaultProps = defaultProps;
export default TextField;
