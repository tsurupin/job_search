import React, { PropTypes, Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as FavoriteJobsActionCreators from './action';
import { FavoriteJobTable } from 'components';
const propTypes = {
  favoriteJobs: PropTypes.array.isRequired,
  loading: PropTypes.bool.isRequired,
  errorMessage: PropTypes.string
}

function mapStateToProps({ favoriteJobIndex }) {
  const { favoriteJobs, loading, errorMessage } = favoriteJobIndex;
  return {
    favoriteJobs,
    loading,
    errorMessage
  }
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      FavoriteJobsActionCreators,
      dispatch
    )
  }
}

class FavoriteJobIndexContainer extends Component {

  constructor(props) {
    super(props);

    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleRemove = this.handleRemove.bind(this);
  }

  componentWillMount() {
    this.props.actions.fetchFavoriteJobs()
  }

  handleUpdate(jobId, params) {
    this.props.actions.updateFavoriteJob(jobId, params)
  }

  handleRemove(jobId, sortRank) {
    this.props.actions.removeFavoriteJob(jobId, sortRank);
  }

  renderFavoriteJobs(favoriteJobs) {
    if (favoriteJobs.length === 0) { return }
    return (
      <FavoriteJobTable
        favoriteJobs={favoriteJobs}
        handleUpdate={this.handleUpdate}
        handleRemove={this.handleRemove}
      />
    );
  }

  render() {
    return (
      <div>
        {this.renderFavoriteJobs(this.props.favoriteJobs)}
      </div>
    )
  }

}

FavoriteJobIndexContainer.propTypes = propTypes;

export default connect(mapStateToProps, mapDispatchToProps)(FavoriteJobIndexContainer);
