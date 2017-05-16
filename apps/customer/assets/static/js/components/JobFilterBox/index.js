import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  CurrentFilterBox,
  SingleSelectField,
  AutoSuggestTextField,
  TextField,
} from 'components';
import { Wrapper, FilterForm } from './styles';

const propTypes = {
  jobTitles: PropTypes.array.isRequired,
  jobTitle: PropTypes.string.isRequired,
  areas: PropTypes.array.isRequired,
  area: PropTypes.string.isRequired,
  suggestedTechKeywords: PropTypes.array.isRequired,
  techKeywords: PropTypes.array.isRequired,
  detail: PropTypes.string.isRequired,
  handleSelect: PropTypes.func.isRequired,
  handleReset: PropTypes.func.isRequired,
  handleResetTechKeyword: PropTypes.func.isRequired,
  handleResetTechKeywords: PropTypes.func.isRequired,
  handleAutoSuggest: PropTypes.func.isRequired,
};

class JobFilterBox extends Component {

  constructor(props) {
    super(props);
  }

  getSelectedItems() {
    const { jobTitle, area, detail, techKeywords } = this.props;
    const items = [];
    if (jobTitle) items.push({ jobTitle });
    if (area) items.push({ area });
    if (detail) items.push({ detail });
    techKeywords.forEach(techKeyword => items.push({ techKeyword }));
    return items;
  }


  render() {
    const {
      jobTitles,
      jobTitle,
      areas,
      area,
      suggestedTechKeywords,
      detail,
      handleReset,
      handleResetTechKeyword,
      handleResetTechKeywords,
      handleSelect,
      handleAutoSuggest,
    } = this.props;


    return (
      <Wrapper>
        <CurrentFilterBox
          items={this.getSelectedItems()}
          handleReset={handleReset}
          handleResetTechKeyword={handleResetTechKeyword}
        />
        <FilterForm>
          <SingleSelectField
            name="jobTitle"
            items={jobTitles}
            currentValue={jobTitle}
            placeholder="Job Title"
            tabIndex={1}
            handleSelect={handleSelect}
          />
          <SingleSelectField
            name="area"
            items={areas}
            currentValue={area}
            placeholder="Area"
            tabIndex={2}
            handleSelect={handleSelect}
          />
          <AutoSuggestTextField
            name="techKeyword"
            suggestedItems={suggestedTechKeywords}
            tabIndex={3}
            placeholder="Enter Techs"
            handleSelect={handleSelect}
            handleResetTechKeywords={handleResetTechKeywords}
            handleAutoSuggest={handleAutoSuggest}
          />
          <TextField
            name="detail"
            currentValue={detail}
            placeholder="Enter Keywords"
            tabIndex={4}
            autoComplete="on"
            handleSelect={handleSelect}
          />
        </FilterForm>
      </Wrapper>
    );
  }

}
JobFilterBox.propTypes = propTypes;
export default JobFilterBox;
