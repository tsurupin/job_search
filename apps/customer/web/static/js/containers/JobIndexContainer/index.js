import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobIndexActionCreators from './action';

const propTypes = {

};

function mapStateToProps({ jobIndex }) {
  const { jobs, errorMessage, loading, jobTitle, area, techs, detail, page, offset } = jobIndex;
  return {
    jobs,
    errorMessage,
    loading,
    jobTitle,
    area,
    techs,
    detail,
    page,
    offset
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
    const { jobTitle, area, techs, detail } = props;
    this.state = {
      jobTitle,
      area,
      techs,
      detail
    }
  }

  componentWillMount() {
    this.props.actions.fetchJobs(this.getSearchPath());
  }

  componentWillReceiveProps(newProps) {
    this.setState(this.updateProps(newProps));
  }

  updateProps(newProps) {
    let updatedProps = {};
    const { jobTitle, area, techs, detail } = this.props;
    const { newJobTitle, newArea, newTechs, newDetail } = newProps;

    if (jobTitle !== newJobTitle) updatedProps['jobTitle'] = newJobTitle;
    if (area !== newArea) updatedProps['area'] = newArea;
    if (techs !== newTechs) updatedProps['techs'] = newTechs;
    if (detail !== newDetail) updatedProps['detail'] = newDetail;

    return updatedProps;
  }

  getSearchPath() {
    let path = '?';
    const { page } = this.props;
    const { jobTitle, area, techs, detail } = this.state;
    path += `page=${page}&`;

    if (jobTitle) path += `job-title=${jobTitle}&`;
    if (area) path += `area=${area}&`;
    if (techs.length > 0) path += `techs=${techs.join(",")}&`;
    if (detail) path += `detail=${detail}`;
    if (path[path.length-1] === '&') return path.slice(0, path.length-1);

    return path;
  }

  render() {
    return (
      <div />
    )
  }
}

JobIndexContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobIndexContainer);
