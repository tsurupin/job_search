import React, { PropTypes, Component } from 'react';

const propTypes = {
  value: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  tabIndex: PropTypes.number.isRequired,
  options: PropTypes.object,
  handleUpdate: PropTypes.func.isRequired
};

class SelectField extends Component {
  constructor(props) {
    super(props);
  }

  getLabelId() {
    return `select-field-${this.props.name}`;
  }

  getOptions() {
    let options = [];
    for (let [k, v]  of Object.entries(this.props.options)) {
      options.push(<option key={k} value={v}>{k}</option>);
    }
    return options;
  }

  render() {
    const { value, name, tabIndex, handleUpdate } = this.props;
    return (
      <div className="form-component">
        <label htmlFor={this.getLabelId()} className="label">{name}</label>
        <select
          id={this.getLabelId()}
          className="form-field"
          defaultValue={value}
          name={name}
          tabIndex={tabIndex}
          onBlur={(event) => handleUpdate(name, event.target.value)}
        >
          {this.getOptions()}
        </select>
      </div>
    );
  }
}

SelectField.propTypes = propTypes;
export default SelectField;