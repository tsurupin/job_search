import React, { PropTypes } from 'react';
import {
  CurrentFilterBox,
  SingleSelectField,
  AutoSuggestTextField,
  TextField
} from 'components';
import styles from './styles.css';


const propTypes = {

};

class JobFilterBox extends Component {

  constructor(props) {
    super(props);
  }

  getSelectedItems() {
    const {jobTitle, area, detail, techKeywords } = this.props;
    let items = [];
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
      techKeywords,
      detail,
      handleReset,
      handleSelect,
      handleAutoSuggest
    } = this.props;

    return(
      <article className={styles.filterBox}>
        <CurrentFilterBox
          items={this.getSelectedItems()}
          handleReset={handleReset()}
        />
        <section className={styles.filterBox}>
          <SingleSelectField
            name='jobTitle'
            items={jobTitles}
            currentValue={jobTitle}
            placeholder='Job Title'
            tabIndex={1}
            handleSelect={handleSelect()}
          />
          <SingleSelectField
            name='area'
            items={areas}
            currentValue={area}
            placeholder='Area'
            tabIndex={2}
            handleSelect={handleSelect()}
          />
          <AutoSuggestTextField
            name='techKeyword'
            suggestedItems={suggestedTechKeywords}
            currentValue={techKeywords}
            tabIndex={3}
            placeholder="Enter Techs"
            handleSelect={handleSelect()}
            handleAutoSuggest={handleAutoSuggest()}
          />
          <TextField
            name='detail'
            currentValue={detail}
            placeholder='Enter Keywords'
            tabIndex={4}
            autoComplete='on'
            handleSelect={handleSelect()}
          />
        </section>
      </article>
    )
  }

};

JobFilterBox.propTypes = propTypes;
export default JobFilterBox;