import React, { PropTypes, Component } from 'react';

const propTypes = {
  name: PropTypes.string.isRequired,
  currentValue: PropTypes.string.isRequired,
  placeholder: PropTypes.string.isRequired,
  tabIndex: PropTypes.number.isRequired,
  autoComplete: PropTypes.string.isRequired,
  handleSelect: PropTypes.func.isRequired
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

  render() {
    const {
      name,
      placeholder,
      tabIndex,
      autoComplete
    } = this.props;
    const { currentValue } = this.state;

    return(
      <div>
        <label
          htmlFor={this.getLabelId()}
        >
          {name}
        </label>
        <input
          id={this.getLabelId()}
          type='text'
          name={name}
          value={currentValue}
          placeholder={placeholder}
          tabIndex={tabIndex}
          autoComplete={autoComplete}
          onChange={e => this.setState({currentValue: e.target.value})}
          onKeyPress={this.handleSelect}
        />
      </div>
    )
  }
}

TextField.propTypes = propTypes;

export default TextField;
