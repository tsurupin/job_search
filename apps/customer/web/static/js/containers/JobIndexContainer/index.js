import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobIndexActionCreators from './action';
import { JobTable } from 'components';

const propTypes = {

};

function mapStateToProps({ jobIndex }) {
  const {
    jobs,
    errorMessage,
    loading,
    jobTitle,
    area,
    detail,
    techKeywords,
    jobTitles,
    areas,
    suggestedTechKeywords,
    page,
    nextPage,
    hasNext
  } = jobIndex;

  return {
    jobs,
    errorMessage,
    loading,
    jobTitle,
    area,
    detail,
    techKeywords,
    jobTitles,
    areas,
    suggestedTechKeywords,
    page,
    nextPage,
    hasNext
  }
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      JobIndexActionCreators,
      dispatch
    )
  }
}

class JobIndexContainer extends Component {
  constructor(props) {
    super(props);

    this.handleReset = this.handleReset.bind(this);
    this.handleSelect = this.handleSelect.bind(this);
    this.handleAutoSuggest = this.handleAutoSuggest.bind(this);
  }

  componentWillMount() {
    this.props.actions.fetchJobs(this.getSearchPath());
  }

  componentWillReceiveProps(newProps) {
    this.setState(this.updateProps(newProps));
  }

  updateProps(newProps) {
    let updatedProps = {};
    const { jobTitle, area, techKeywords, detail } = this.props;

    if (jobTitle !== newProps.jobTitle) updatedProps['jobTitle'] = newProps.jobTitle;
    if (area !== newProps.Area) updatedProps['area'] = newProps.Area;
    if (techKeywords !== newProps.techKeywords) updatedProps['techKeywords'] = newProps.techKeywords;
    if (detail !== newProps.detail) updatedProps['detail'] = newProps.detail;

    return updatedProps;
  }

  getSearchPath() {
    let path = '?';
    const { page } = this.props;
    const { jobTitle, area, techKeywords, detail } = this.props;
    path += `page=${page}&`;

    if (jobTitle) path += `job-title=${jobTitle}&`;
    if (area) path += `area=${area}&`;
    if (techKeywords.length > 0) path += `techs=${techKeywords.join(",")}&`;
    if (detail) path += `detail=${detail}`;
    if (path[path.length-1] === '&') return path.slice(0, path.length-1);

    return path;
  }

  handleReset(key) {
    this.props.actions.resetItem(key);
  }

  handleSelect(key, value) {
    this.props.actions.selectItem(key, value);
  }

  handleAutoSuggest(value) {
    this.props.actions.fetchTechKeywords(value);
  }

  render() {
    const {
      jobs,
      jobTitles,
      jobTitle,
      areas,
      area,
      suggestedTechKeywords,
      techKeywords,
      detail
    } = this.props;

    return (
      <article>
        <JobFilterBox
          jobTitle={jobTitle}
          area={area}
          detail={detail}
          techKeywords={techKeywords}
          jobTitles={jobTitles}
          areas={areas}
          suggestedTechKeywords={suggestedTechKeywords}
          handleSelect={this.handleSelect()}
          handleReset={this.handleReset()}
          handleAutoSuggest={this.handleAutoSuggest()}
        />
        {jobs.length === 0 ? null : <JobTable jobs={jobs} />}
      </article>
    )
  }
}

JobIndexContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobIndexContainer);
