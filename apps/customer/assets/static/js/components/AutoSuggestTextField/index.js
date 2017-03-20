import React, { Component, PropTypes } from 'react';
import Wrapper from './Wrapper';
import Input from './Input';
import { Label, SuggestedItemList } from 'components';

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

  renderSuggestedItemList() {
    const { suggestedItems, name } = this.props;
    if (suggestedItems.length === 0) return;
    return(
      <SuggestedItemList name={name} suggestedItems={suggestedItems} handleSelect={this.props.handleSelect} />
    )
  }


  render() {
    const {
      name,
      tabIndex,
      placeholder
    } = this.props;
    const { currentValue } = this.state;

    return(
      <Wrapper>
        <Label htmlFor={this.getLabelId()} >{name}</Label>
        <Input
          id={this.getLabelId()}
          type='text'
          name={name}
          placeholder={placeholder}
          tabIndex={tabIndex}
          onChange={this.handleAutoSuggest}
          onKeyPress={this.handleSelect}
          defaultValue={currentValue}
        />
        {this.renderSuggestedItemList()}
      </Wrapper>
    )
  }
}


AutoSuggestTextField.propTypes = propTypes;
export default AutoSuggestTextField;