import React, { Component, PropTypes } from 'react';


const propTypes = {
  name: PropTypes.string.isRequired,
  suggestedItems: PropTypes.arrayOf(PropTypes.string).isRequired,
  currentValue: PropTypes.arrayOf(PropTypes.string),
  tabIndex: PropTypes.number.isRequired,
  placeholder: PropTypes.string.isRequired,
  handleAutoSuggest: PropTypes.func.isRequired,
  handleSelect: PropTypes.func.isRequired,
};

class AutoSuggestTextField extends Component {

  constructor(props) {
    super(props);

    this.state = { currentValue: '' };
    this.handleAutoSuggest = this.handleAutoSuggest.bind(this);
    this.handleSelect = this.handleSelect.bind(this);
  }

  handleAutoSuggest(e) {
    const { value } = e.target;
    this.props.handleAutoSuggest(value);
  }

  handleSelect(e) {
    if (e.key !== 'Enter') return;
    this.props.handleSelect(e.target.name, e.target.value);
  }

  getLabelId() {
    return `${this.props.name}-suggested-text`;
  }


  render() {
    const {
      name,
      suggestedItems,
      tabIndex,
      placeholder
    } = this.props;
    const { currentValue } = this.state;

    return(
      <div>
      <label htmlFor={this.getLabelId()} >{name}</label>
        <input
          id={this.getLabelId()}
          type='text'
          name={name}
          placeholder={placeholder}
          tabIndex={tabIndex}
          onChange={this.handleAutoSuggest}
          onKeyPress={this.handleSelect}
          defaultValue={currentValue}
        />
        <ul>
          {suggestedItems.map((suggestedItem) => {
            return(
              <li key={suggestedItem} onClick={() => this.props.handleSelect(name, suggestedItem)} >
                {suggestedItem}
              </li>
            )
          })
          }
        </ul>
      </div>
    )
  }
}


AutoSuggestTextField.propTypes = propTypes;
export default AutoSuggestTextField;