import React from 'react';
import PropTypes from 'prop-types';
import { Wrapper } from './styles';

const propTypes = {
  jobId: PropTypes.number.isRequired,
  favorited: PropTypes.bool.isRequired,
  submitting: PropTypes.bool.isRequired,
  index: PropTypes.number.isRequired,
  size: PropTypes.string.isRequired,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired,
};

const defaultProps = {
  index: 0,
  size: 'middle',
  submitting: false,
};

const FavoriteJobButton = ({ jobId, favorited, submitting, index, size, handleSwitchFavoriteStatus }) => (
  <Wrapper
    type="button"
    onClick={() => handleSwitchFavoriteStatus(index, jobId, !favorited)}
    primary={size === 'large'}
    disabled={submitting}
  >
    {renderText(favorited)}
  </Wrapper>
    );

function renderText(favorited) {
  if (favorited) { return 'UnFavorite'; }
  return 'Favorite';
}

FavoriteJobButton.propTypes = propTypes;
FavoriteJobButton.defaultProps = defaultProps;
export default FavoriteJobButton;
