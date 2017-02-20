import React, { Component, PropTypes } from 'react';


const propTypes = {

};

class AutoSuggestTextField extends Component {

  constructor(props) {
    super(props);

    this.handleChange = this.handleChange.bind(this);
    this.handleSelect = this.handleSelect.bind(this);
    this.handleSelectSuggestedItem = this.handleSelectSuggestedItem.bind(this);
  }

  handleChange(e) {
    e.preventDefault();
    this.props.handleChange(e.target.value);
  }

  handleSelect(e) {
    e.preventDefault();
    this.props.handleSelect(e.target.name, e.target.value);
  }

  handleSelectSuggestedItem(value) {
    this.props.handleSelect(this.props.name, value);
  }

  getLabelId() {
    return  `${name}-suggested-text`;
  }


  render() {
    const { name, suggestedItems, currentValue, tabIndex, placeholder } = this.props;
    return(
      <div>
      <label htmlFor={this.getLabelId()} >{name}</label>
        <input
          id={this.getLabelId()}
          type='text'
          placeholder={placeholder}
          tabIndex={tabIndex}
          onChange={this.handleChange()}
          onClick={this.handleSelect()}
          value={currentValue}
        />
        <ul>
          {suggestedItems.map((suggestedItem) => {
            return(
              <li key={suggestedItem} onClick={this.handleSelectSuggestedItem(suggestedItem)}>
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