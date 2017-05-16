import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as FavoriteJobsActionCreators from './action';
import { FavoriteJobList, LoadingMessage, Title } from 'components';

const propTypes = {
  favoriteJobs: PropTypes.arrayOf(
    PropTypes.shape({
      interest: PropTypes.number.isRequired,
      jobId: PropTypes.number.isRequired,
      jobTitle: PropTypes.string.isRequired,
      area: PropTypes.string.isRequired,
      status: PropTypes.number,
      company: PropTypes.string.isRequired,
      remarks: PropTypes.string,
    }),
  ).isRequired,
  loading: PropTypes.bool.isRequired,
  errorMessage: PropTypes.string,
};

import { Wrapper } from './styles';

function mapStateToProps({ favoriteJobIndex }) {
  const { favoriteJobs, loading, errorMessage } = favoriteJobIndex;
  return {
    favoriteJobs,
    loading,
    errorMessage,
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      FavoriteJobsActionCreators,
      dispatch,
    ),
  };
}

class FavoriteJobIndexContainer extends Component {

  constructor(props) {
    super(props);

    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleRemove = this.handleRemove.bind(this);
  }

  componentWillMount() {
    this.props.actions.fetchFavoriteJobs();
  }

  handleUpdate(jobId, params) {
    this.props.actions.updateFavoriteJob(jobId, params);
  }

  handleRemove(jobId, sortRank) {
    this.props.actions.removeFavoriteJob(jobId, sortRank);
  }

  renderFavoriteJobs(favoriteJobs) {
    if (favoriteJobs.length === 0) { return <p>You don't have favorite jobs yet!</p>; }
    return (
      <FavoriteJobList
        favoriteJobs={favoriteJobs}
        handleUpdate={this.handleUpdate}
        handleRemove={this.handleRemove}
      />
    );
  }

  render() {
    if (this.props.loading) { return <LoadingMessage />; }
    return (
      <Wrapper>
        <Title>Favorite Jobs</Title>
        {this.renderFavoriteJobs(this.props.favoriteJobs)}
      </Wrapper>
    );
  }

}

FavoriteJobIndexContainer.propTypes = propTypes;

export default connect(mapStateToProps, mapDispatchToProps)(FavoriteJobIndexContainer);
