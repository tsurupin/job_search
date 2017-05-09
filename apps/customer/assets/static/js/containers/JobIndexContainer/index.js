import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobIndexActionCreators from './action';
import { JobList, JobFilterBox } from 'components';
import { TECH_KEYWORD } from 'constants';
import Infinite from 'react-infinite';
import Wrapper from './styles'
const propTypes = {
  jobTitles: PropTypes.array.isRequired,
  jobTitle: PropTypes.string.isRequired,
  areas: PropTypes.array.isRequired,
  area: PropTypes.string.isRequired,
  jobs: PropTypes.array.isRequired,
  suggestedTechKeywords: PropTypes.array.isRequired,
  techKeywords: PropTypes.arrayOf(PropTypes.string.isRequired).isRequired,
  detail: PropTypes.string.isRequired,
  page: PropTypes.number.isRequired,
  nextPage: PropTypes.number.isRequired,
  hasNext: PropTypes.bool.isRequired,
  errorMessage: PropTypes.string.isRequired,
  actions: PropTypes.shape({
    selectItem: PropTypes.func.isRequired,
    resetItem: PropTypes.func.isRequired,
    fetchTechKeywords: PropTypes.func.isRequired,
    resetTechKeywords: PropTypes.func.isRequired
  }).isRequired
};

const TECH_KEYWORDS = 'techKeywords';

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
    this.handleResetTechKeyword = this.handleResetTechKeyword.bind(this);
    this.handleSelect = this.handleSelect.bind(this);
    this.handleAutoSuggest = this.handleAutoSuggest.bind(this);
    this.handleSwitchFavoriteStatus = this.handleSwitchFavoriteStatus.bind(this);
    this.handleResetTechKeywords = this.handleResetTechKeywords.bind(this);
    //this.handleLoad = this.handleLoad.bind(this);
  }

  componentWillMount() {
    this.props.actions.fetchJobs(this.getSearchPath(this.props));
  }

  componentWillReceiveProps(newProps) {
    if (this.needUpdate(newProps)) {
      this.props.actions.fetchJobs(this.getSearchPath(newProps));
    }
  }

  needUpdate(newProps) {
    let updatedProps = {};
    const { jobTitle, area, techKeywords, detail } = this.props;

    if (jobTitle !== newProps.jobTitle) updatedProps['jobTitle'] = newProps.jobTitle;
    if (area !== newProps.area) updatedProps['area'] = newProps.area;
    if (techKeywords !== newProps.techKeywords) updatedProps['techKeywords'] = newProps.techKeywords;
    if (detail !== newProps.detail) updatedProps['detail'] = newProps.detail;

    return Object.keys(updatedProps).length > 0
  }

  getSearchPath(props) {
    let path = '?';
    const { page } = props;
    const { jobTitle, area, techKeywords, detail } = props;
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

  handleSwitchFavoriteStatus(sortRank, jobId, favorited) {
    if (favorited) {
      this.props.actions.favoriteJob(sortRank, jobId, favorited)
    } else {
      this.props.actions.unfavoriteJob(sortRank, jobId, favorited)
    }
  }

  handleResetTechKeyword(_key, value) {
    const newValue = this.props.techKeywords.filter(techKeyword => techKeyword !== value);
    this.props.actions.selectItem(TECH_KEYWORDS, newValue);
  }

  handleResetTechKeywords() {
    this.props.actions.resetTechKeywords();
  }

  handleSelect(key, value) {
    if (key === TECH_KEYWORD) {
      value = [...this.props.techKeywords, value];
      this.props.actions.selectItem(TECH_KEYWORDS, value);
      this.props.actions.resetTechKeywords();
    } else {
      this.props.actions.selectItem(key, value);
    }

  }

  // handleLoad() {
  //   if (this.canLoad) {
  //     const params = { page: this.props.page + 1 };
  //
  //     if (this.props.params.hasOwnProperty('location')) {
  //       params.tagId = this.props.params.location.query['tag-id'];
  //     }
  //     this.props.fetchPosts(params);
  //   }
  // }


  handleAutoSuggest(value) {
    this.props.actions.fetchTechKeywords(value);
  }

  renderJobs(jobs) {
    if (jobs.length === 0) { return }
    return (
      <JobList jobs={jobs} handleSwitchFavoriteStatus={this.handleSwitchFavoriteStatus} />
    )
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
      <Wrapper>
        <JobFilterBox
          jobTitle={jobTitle}
          area={area}
          detail={detail}
          techKeywords={techKeywords}
          jobTitles={jobTitles}
          areas={areas}
          suggestedTechKeywords={suggestedTechKeywords}
          handleSelect={this.handleSelect}
          handleReset={this.handleReset}
          handleResetTechKeyword={this.handleResetTechKeyword}
          handleAutoSuggest={this.handleAutoSuggest}
          handleResetTechKeywords={this.handleResetTechKeywords}
        />
        {this.renderJobs(jobs)}
      </Wrapper>
    )
  }
}

JobIndexContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobIndexContainer);
