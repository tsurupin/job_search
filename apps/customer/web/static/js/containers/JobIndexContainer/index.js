import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobIndexActionoCreators from './action';

const propTypes = {

}

function mapStateToProps({ jobIndex }) {
  const { jobs, errorMessage, loading } = jobIndex;
  return {
    jobs,
    errorMessage,
    loading
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
  }

  componentWillMount() {
    this.props.actions.fetchJobs();
  }

  render() {
    return (
      <div />
    )
  }
}

JobIndexContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobIndexContainer);
